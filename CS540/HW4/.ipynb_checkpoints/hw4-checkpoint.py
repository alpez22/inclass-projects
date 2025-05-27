import geopandas
import numpy as np
from matplotlib import pyplot as plt
import csv
from scipy.spatial.distance import pdist, squareform
from scipy.cluster.hierarchy import dendrogram

#section 4.1
def load_data(filepath):
    #reads a csv file and returns a list of dictionaries, where each row is represented as a dictionary with column headers as keys
    data = []
    with open(filepath, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file)
        for row in reader:
            data.append(dict(row))
    return data

#section 4.2: row dictionary -> feature vector
def calc_features(row):
    #turns dict of country's data & extracts the 9 relevant socioeconomic features, returns (9,)
    feature_names = ["child_mort", "exports", "health", "imports", 
                     "income", "inflation", "life_expec", "total_fer", "gdpp"]
    feature_vector = np.array([float(row[feature]) for feature in feature_names], dtype=np.float64)
    return feature_vector

#section 4.5: normalizes feature vectors
def normalize_features(features):
    #normalizes each feature by subtracting the mean and dividing by the standard deviation, returns list of normalized arrays
    features_array = np.array(features)  # list -> 2D NumPy array
    means = np.mean(features_array, axis=0)
    stds = np.std(features_array, axis=0)
    
    normalized_features = (features_array - means) / stds
    return list(normalized_features)

#complete-linkage hierarchical agglomerative clustering
def hac(features):
    n = len(features)
    clusters = {i: [i] for i in range(n)}  # points -> each cluster
    distances = squareform(pdist(features, metric='euclidean'))
    np.fill_diagonal(distances, np.inf)  # avoid self-merging

    Z = np.zeros((n - 1, 4))
    active_clusters = list(range(n))
    next_cluster_id = n

    for step in range(n - 1):
        #find the closest two clusters
        min_dist = np.inf
        merge_i, merge_j = -1, -1
        
        for i in range(len(active_clusters)):
            for j in range(i + 1, len(active_clusters)):
                a, b = active_clusters[i], active_clusters[j]
                dist = distances[a, b]
                if dist < min_dist:
                    min_dist, merge_i, merge_j = dist, a, b

        #tie-break ordering
        i, j = min(merge_i, merge_j), max(merge_i, merge_j)

        #complete-linkage distance
        new_cluster_members = clusters[i] + clusters[j]
        max_dist = max(distances[a, b] for a in clusters[i] for b in clusters[j])

        #merge result
        Z[step] = [i, j, max_dist, len(new_cluster_members)]

        #add new cluster & remove old clusters
        clusters[next_cluster_id] = new_cluster_members
        del clusters[i], clusters[j]
        active_clusters.remove(i)
        active_clusters.remove(j)
        active_clusters.append(next_cluster_id)

        # expand distance matrix to accommodate new clusters
        new_size = len(distances) + 1
        new_distances = np.full((new_size, new_size), np.inf)
        new_distances[:-1, :-1] = distances  #copy old distances
        
        #update distances for new cluster
        for k in active_clusters[:-1]:
            dist_k = max(distances[min(i, k), max(i, k)], distances[min(j, k), max(j, k)])
            new_distances[k, next_cluster_id] = dist_k
            new_distances[next_cluster_id, k] = dist_k
        
        distances = new_distances

        next_cluster_id += 1

    return Z

#section 4.4: dendrogram visualization
def fig_hac(Z, names):
    #hierarchical clustering result Z and country names -> Matplotlib plot
    fig, ax = plt.subplots(figsize=(12, 6))
    dendrogram(Z, labels=names, leaf_rotation=90, ax=ax)
    plt.tight_layout()
    return fig

#apart of starter code
def world_map(Z, names, K_clusters):
    world = geopandas.read_file(geopandas.datasets.get_path('naturalearth_lowres'))

    world['name'] = world['name'].str.strip()
    names = [name.strip() for name in names]

    world['cluster'] = np.nan

    n = len(names)
    clusters = {j: [j] for j in range(n)}

    for step in range(n-K_clusters):
        cluster1 = Z[step][0]
        cluster2 = Z[step][1]

        # Create new cluster id as n + step
        new_cluster_id = n + step

        # Merge clusters
        clusters[new_cluster_id] = clusters.pop(cluster1) + clusters.pop(cluster2)

    # Assign cluster labels to countries in the world dataset
    for i, value in enumerate(clusters.values()):
        for val in value:
            world.loc[world['name'] == names[val], 'cluster'] = i

    # Plot the map
    world.plot(column='cluster', legend=True, figsize=(15, 10), missing_kwds={
        "color": "lightgrey",  # Set the color of countries without clusters
        "label": "Other countries"
    })

    # Show the plot
    plt.show()

if __name__ == "__main__":
    data = load_data("Country-data.csv")
    features = [calc_features(row) for row in data]
    names = [row["country"] for row in data]
    
    features_normalized = normalize_features(features)

    # save normalized features for comparison and compare w/ output.txt
    np.savetxt("my_normalized_output.txt", features_normalized, fmt="%.18e")
    expected_features = np.loadtxt("output.txt")

    if expected_features.shape != np.array(features_normalized).shape:
        print(f"Issue: shape mismatch... expected: {expected_features.shape} --- got: {np.array(features_normalized).shape}")
    else:
        difference = np.abs(expected_features - np.array(features_normalized))

        # is difference within an acceptable tolerance (e.g., 1e-6)
        if np.all(difference < 1e-6):
            print("Good: your normalized features match the expected output")
        else:
            print("Issue: differences found in normalized features")
            print("max difference:", np.max(difference))

            for i in range(len(expected_features)):
                if not np.allclose(expected_features[i], np.array(features_normalized)[i], atol=1e-6):
                    print(f"Mismatch at row {i}:")
                    print(f"Expected: {expected_features[i]}")
                    print(f"Got: {np.array(features_normalized)[i]}")

    # run HAC on the first 50 normalized feature vectors
    features_subset = features_normalized[:50]
    Z = hac(features_subset)

    # save HAC output
    np.savetxt("my_hac_output.txt", Z, fmt="%.6f")

    # visualize the hierarchical clustering dendrogram
    fig = fig_hac(Z, names[:50])
    fig.show()

    # run additional tests with different n values
    n = 20
    Z_20 = hac(features_normalized[:n])
    fig = fig_hac(Z_20, names[:n])
    fig.show()

    n = 30
    Z_30 = hac(features_normalized[:n])
    fig = fig_hac(Z_30, names[:n])
    fig.show()

    # optional: visualize clustering on a world map
    import random
    random_indices = random.sample(range(0, len(names)), 100)
    random_names = [names[i] for i in random_indices]
    random_features = [features_normalized[i] for i in random_indices]
    Z_map = hac(random_features)
    world_map(Z_map, random_names, 10)