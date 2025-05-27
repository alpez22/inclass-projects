from scipy.linalg import eigh
import numpy as np
import matplotlib.pyplot as plt

def load_and_center_dataset(filename):
    dataset = np.load(filename).astype(np.float64)  # Load dataset
    mean_face = np.mean(dataset, axis=0)  # Compute mean image
    return dataset - mean_face  # Return centered dataset

def get_covariance(dataset):
    n = dataset.shape[0]  # Number of samples
    return np.dot(dataset.T, dataset) / (n - 1)  # (d x d) covariance matrix

def get_eig(S, k):
    eigvals, eigvecs = eigh(S)  # Compute eigenvalues & eigenvectors
    sorted_indices = np.argsort(eigvals)[::-1]  # Sort indices in descending order
    top_eigvals = eigvals[sorted_indices][:k]  # Top k eigenvalues
    top_eigvecs = eigvecs[:, sorted_indices][:, :k]  # Top k eigenvectors
    return np.diag(top_eigvals), top_eigvecs  # Return eigenvalues as a diagonal matrix

def get_eig_prop(S, prop):
    eigvals, eigvecs = eigh(S)  # Compute all eigenvalues
    eigvals = eigvals[::-1]  # Sort descending
    total_variance = np.sum(eigvals)  # Total variance
    variance_sum = 0
    k = 0
    while variance_sum / total_variance < prop:  # Accumulate variance
        variance_sum += eigvals[k]
        k += 1
    return get_eig(S, k)  # Use get_eig to return the top k

def get_eig_prop2(S, prop):
    eigvals, eigvecs = eigh(S)  # Compute all eigenvalues and eigenvectors
    eigvals = eigvals[::-1]  # Sort eigenvalues in descending order
    eigvecs = eigvecs[:, ::-1]  # Sort eigenvectors accordingly
    
    total_variance = np.sum(eigvals)  # Compute total variance
    variance_sum = 0
    k = 0
    
    # Select the smallest k such that the cumulative variance is at least prop
    while variance_sum / total_variance < prop:
        variance_sum += eigvals[k]
        k += 1

    # Extract the top k eigenvalues and eigenvectors
    selected_eigvals = eigvals[:k]
    selected_eigvecs = eigvecs[:, :k]

    # Return eigenvalues as a diagonal matrix
    return np.diag(selected_eigvals), selected_eigvecs
    
def project_and_reconstruct_image(image, U):
    projected = np.dot(image, U)  # Project onto principal components
    reconstructed = np.dot(projected, U.T)  # Reconstruct image
    return reconstructed.reshape(-1, 1)  # Ensure shape is (d, 1)

def project_and_reconstruct_image2(image, U):
    projected = np.dot(image, U)  # Project onto principal components
    reconstructed = np.dot(projected, U.T)  # Reconstruct image
    return reconstructed.flatten()  # Ensure output is (3000,) instead of (3000, 1)

def project_and_reconstruct_image3(image, U):
    projected = np.dot(U.T, image)  # Step 1: Project into PCA subspace
    reconstructed = np.dot(U, projected)  # Step 2: Reconstruct from projection
    return reconstructed  # Ensure shape is (3000,)
    
def display_image(im_orig_fullres, im_orig, im_reconstructed):
    # Please use the format below to ensure grading consistency
    fig, (ax1, ax2, ax3) = plt.subplots(figsize=(9,3), ncols=3)
    fig.tight_layout()

    ax1.imshow(im_orig_fullres)  # High-resolution image
    ax1.set_title("Original High-Res")
    ax1.axis("off")

    ax2.imshow(im_orig.reshape(60, 50), cmap="gray")  # Low-res image
    ax2.set_title("Original Low-Res")
    ax2.axis("off")

    ax3.imshow(im_reconstructed.reshape(60, 50), cmap="gray")  # Reconstructed image
    ax3.set_title("Reconstructed")
    ax3.axis("off")

    plt.show()
    return fig, ax1, ax2, ax3

def display_image2(im_orig_fullres, im_orig, im_reconstructed):
    # Step 1: Create the figure with 3 subplots
    fig, (ax1, ax2, ax3) = plt.subplots(figsize=(9, 3), ncols=3)
    fig.tight_layout()

    # Step 2: Display original high-res image
    ax1.imshow(im_orig_fullres)  # Full-resolution image
    ax1.set_title("Original High Res")
    ax1.axis("off")

    # Step 3: Display original low-res image
    ax2.imshow(im_orig.reshape(60, 50), cmap="gray", aspect='equal')  # Low-res grayscale
    ax2.set_title("Original")
    ax2.axis("off")

    # Step 4: Display reconstructed image
    ax3.imshow(im_reconstructed.reshape(60, 50), cmap="gray", aspect='equal')  # Reconstructed image
    ax3.set_title("Reconstructed")
    ax3.axis("off")

    # Step 5: Add colorbar for ax2 and ax3
    cbar2 = plt.colorbar(ax2.imshow(im_orig.reshape(60, 50), cmap="gray", aspect='equal'), ax=ax2)
    cbar3 = plt.colorbar(ax3.imshow(im_reconstructed.reshape(60, 50), cmap="gray", aspect='equal'), ax=ax3)

    return fig, ax1, ax2, ax3

def perturb_image(image, U, sigma):
    projected = np.dot(image, U)  # Project image onto PCA basis
    noise = np.random.normal(0, sigma, size=projected.shape)  # Gaussian noise
    noisy_projected = projected + noise
    return np.dot(noisy_projected, U.T).reshape(-1, 1)  # Reconstruct & reshape

def perturb_image2(image, U, sigma):
    projected = np.dot(U.T, image)  # Step 1: Project image onto PCA basis
    noise = np.random.normal(0, sigma, size=projected.shape)  # Step 2: Add Gaussian noise
    noisy_projected = projected + noise  # Perturb the projection weights
    reconstructed_noisy = np.dot(U, noisy_projected)  # Step 3: Reconstruct image from perturbed weights
    return reconstructed_noisy  # Ensure shape is (3000,)


def main():
    # Step 1: Load and Center Dataset
    print("Loading dataset...")
    x = load_and_center_dataset("celeba_60x50.npy")
    print("Dataset shape:", x.shape)  # Expected: (100, 3000)
    print("Mean (should be close to 0):", np.mean(x))  # Expected: close to 0
    print("Column-wise mean (should be very small):", np.mean(x, axis=0)[:10])  # First 10 values

    # Step 2: Compute Covariance Matrix
    print("\nComputing covariance matrix...")
    S = get_covariance(x)
    print("Covariance shape:", S.shape)  # Expected: (3000, 3000)

    # Step 3: Compute Top k Eigenvalues and Eigenvectors
    k = 10
    print(f"\nComputing top {k} eigenvalues and eigenvectors...")
    eigvals, eigvecs = get_eig(S, k)
    print("Eigenvalues matrix shape:", eigvals.shape)  # Expected: (10, 10)
    print("Eigenvectors shape:", eigvecs.shape)  # Expected: (3000, 10)

    # Compute top 3 eigenvalues and eigenvectors
    Lambda, U = get_eig(S, 3)
    print("Lambda (Diagonal Matrix):\n", Lambda)
    print("\nU (Eigenvectors Matrix):\n", U[:10, :])  # Print only first 10 rows for readability

    # Step 4: Compute Eigenvectors for 90% Variance
    print("\nFinding number of eigenvectors needed for 90% variance...")
    eigvals_prop, eigvecs_prop = get_eig_prop(S, 0.9)
    print("Number of eigenvectors for 90% variance:", len(eigvals_prop))

    # Get eigenvalues/eigenvectors for p = 0.07 (7% of variance)
    Lambda, U = get_eig_prop2(S, 0.07)

    print("Lambda (Diagonal Matrix):\n", Lambda)
    print("\nU (Eigenvectors Matrix):\n", U[:10, :])  # Print only first 10 rows for readability

    # Step 5: Project and Reconstruct an Image
    print("\nProjecting and reconstructing an image...")
    image = x[0]  # Select the first image
    reconstructed_image = project_and_reconstruct_image(image, eigvecs)
    print("Reconstructed image shape:", reconstructed_image.shape)  # Expected: (3000, 1)

    # Check shape : project_and_reconstruct_image3
    #print("Original image shape:", image.shape)  # Expected: (3000,)
    #print("Reconstructed image shape:", reconstructed_image.shape)  # Expected: (3000,)

    # Step 6: Load Full-Resolution Image and Display
    print("\nDisplaying original vs reconstructed image...")
    fullres_image = np.load("celeba_218x178x3.npy")[0]  # Load high-res image
    fullres_image = fullres_image.reshape(218, 178, 3)  # Reshape it correctly
    display_image(fullres_image, image, reconstructed_image)

    #fullres_image = np.load("celeba_218x178x3.npy")[0]
    #display_image(fullres_image, image, reconstructed_image)

    # Pick an index for a celebrity 2
    celeb_idx = 34  # You can change this to test different images
    x = X[celeb_idx]

    # Load the high-res image
    x_fullres = np.load('celeba_218x178x3.npy')[celeb_idx]

    # Project and reconstruct the image
    reconstructed = project_and_reconstruct_image(x, U)

    # Display the images
    fig, ax1, ax2, ax3 = display_image(x_fullres, x, reconstructed)
    plt.show()

    # Step 7: Perturb an Image with Noise
    sigma = 0.1
    print("\nAdding noise and reconstructing image...")
    noisy_image = perturb_image(image, eigvecs, sigma)
    display_image(fullres_image, image, noisy_image)

    # Pick an index for a celebrity 2
    celeb_idx = 34  # You can change this to test different images
    x = X[celeb_idx]

    # Load the high-res image
    x_fullres = np.load('celeba_218x178x3.npy')[celeb_idx]

    # Project, perturb, and reconstruct the image
    sigma = 1000  # Standard deviation of noise
    x_perturbed = perturb_image(x, U, sigma)

    # Display the images
    fig, ax1, ax2, ax3 = display_image(x_fullres, x, x_perturbed)
    plt.show()

    
    print("\nAll tests completed successfully!")

# Standard Python entry point
if __name__ == "__main__":
    main()