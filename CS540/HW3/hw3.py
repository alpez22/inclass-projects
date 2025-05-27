from scipy.linalg import eigh
import numpy as np
import matplotlib.pyplot as plt

def load_and_center_dataset(filename):
    dataset = np.load(filename).astype(np.float64)
    mean_face = np.mean(dataset, axis=0)  #compute mean image
    return dataset - mean_face  #centered dataset

def get_covariance(dataset):
    n = dataset.shape[0]  #num of samples
    return np.dot(dataset.T, dataset) / (n - 1)  # (d x d) covariance matrix

def get_eig(S, k):
    eigvals, eigvecs = eigh(S)
    sorted_eigvals = np.argsort(eigvals)[::-1]  #sort in descending order
    top_k_eigvals = eigvals[sorted_eigvals][:k]  #top k eigenvalues
    top_k_eigvecs = eigvecs[:, sorted_eigvals][:, :k]  #top k eigenvectors
    return np.diag(top_k_eigvals), top_k_eigvecs  #return eigenvalues as a diagonal matrix

def get_eig_prop(S, prop):
    eigvals, eigvecs = eigh(S)
    eigvals = eigvals[::-1]
    eigvecs = eigvecs[:, ::-1]
    
    total_variance = np.sum(eigvals)
    variance_threshold = prop * total_variance

    #get eigenvalues greater than or equal to the threshold
    selected_eigvals = np.where(eigvals >= variance_threshold)[0]

    returned_eigvals = eigvals[selected_eigvals]
    returned_eigvecs = eigvecs[:, selected_eigvals]

    #return eigenvalues as a diagonal matrix
    return np.diag(returned_eigvals), returned_eigvecs

def project_and_reconstruct_image(image, U):
    projected = np.dot(U.T, image)  #project into PCA subspace
    reconstructed = np.dot(U, projected)  # reconstruct from projection
    return reconstructed  #ensure shape is (3000,)

def display_image(im_orig_fullres, im_orig, im_reconstructed):
    # Please use the format below to ensure grading consistency
    fig, (ax1, ax2, ax3) = plt.subplots(figsize=(9, 3), ncols=3)
    fig.tight_layout()

    im_orig_fullres = im_orig_fullres.reshape(218, 178, 3)
    im_orig = im_orig.reshape(60, 50)
    im_reconstructed = im_reconstructed.reshape(60, 50)
    
    # display original high-res image
    ax1.imshow(im_orig_fullres)
    ax1.set_title("Original High Res")
    ax1.axis("off")

    # display original low-res image
    image2 = ax2.imshow(im_orig, cmap="gray", aspect='equal')
    ax2.set_title("Original")
    ax2.axis("off")
    fig.colorbar(image2, ax=ax2)

    # display reconstructed image
    image3 = ax3.imshow(im_reconstructed, cmap="gray", aspect='equal')
    ax3.set_title("Reconstructed")
    ax3.axis("off")
    fig.colorbar(image3, ax=ax3)

    return fig, ax1, ax2, ax3

def perturb_image(image, U, sigma):
    projected = np.dot(U.T, image)  # project image onto PCA basis
    noise = np.random.normal(0, sigma, size=projected.shape)  #add Gaussian noise
    noisy_projected = projected + noise  # perturb the projection weights
    reconstructed_noisy = np.dot(U, noisy_projected)  #reconstruct image from perturbed weights
    return reconstructed_noisy  #shape is (3000,)