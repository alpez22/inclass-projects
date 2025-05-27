import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms



def get_data_loader(training = True):
    """
    Creates a DataLoader for the FashionMNIST dataset

    INPUT: 
        An optional boolean argument (default value is True for training dataset)

    RETURNS:
        Dataloader for the training set (if training = True) or the test set (if training = False)
    """
    transform=transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
        ])
    dataset = datasets.FashionMNIST('./data', train=training, download=True, transform=transform)
    return torch.utils.data.DataLoader(dataset, batch_size=64, shuffle=training)


def build_model():
    """
    Builds a simple neural network model

    INPUT: 
        None

    RETURNS:
        An untrained neural network model
    """
    model = nn.Sequential(
        nn.Flatten(),
        nn.Linear(28*28, 128),
        nn.ReLU(),
        nn.Linear(128, 64),
        nn.ReLU(),
        nn.Linear(64, 10)
    )
    return model



def build_deeper_model():
    """
    Builds a deeper neural network model

    INPUT: 
        None

    RETURNS:
        An untrained neural network model
    """
    model = nn.Sequential(
        nn.Flatten(),
        nn.Linear(28*28, 256),
        nn.ReLU(),
        nn.Linear(256, 128),
        nn.ReLU(),
        nn.Linear(128, 64),
        nn.ReLU(),
        nn.Linear(64, 32),
        nn.ReLU(),
        nn.Linear(32, 10)
    )
    return model



def train_model(model, train_loader, criterion, T):
    """
    Trains the model using the given data loader

    INPUT: 
        model - the model produced by the previous function
        train_loader  - the train DataLoader produced by the first function
        criterion   - cross-entropy 
        T - number of epochs for training

    RETURNS:
        None
    """
    optimizer = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)
    model.train()
    
    for epoch in range(T):
        correct = 0
        total_loss = 0
        
        for images, labels in train_loader:
            optimizer.zero_grad()
            outputs = model(images)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            
            total_loss += loss.item() * images.size(0)
            _, predicted = torch.max(outputs, 1)
            correct += (predicted == labels).sum().item()
        
        accuracy = 100.0 * correct / len(train_loader.dataset)
        avg_loss = total_loss / len(train_loader.dataset)
        print(f"Train Epoch: {epoch} Accuracy: {correct}/{len(train_loader.dataset)} ({accuracy:.2f}%) Loss: {avg_loss:.3f}")
    


def evaluate_model(model, test_loader, criterion, show_loss = True):
    """
    Evaluates the trained model on test data

    INPUT: 
        model - the the trained model produced by the previous function
        test_loader    - the test DataLoader
        criterion   - cropy-entropy 

    RETURNS:
        None
    """
    model.eval()
    correct = 0
    total_loss = 0
    
    with torch.no_grad():
        for images, labels in test_loader:
            outputs = model(images)
            loss = criterion(outputs, labels)
            total_loss += loss.item() * images.size(0)
            _, predicted = torch.max(outputs, 1)
            correct += (predicted == labels).sum().item()
    
    accuracy = 100.0 * correct / len(test_loader.dataset)
    avg_loss = total_loss / len(test_loader.dataset)
    
    if show_loss:
        print(f"Average loss: {avg_loss:.4f}")
    print(f"Accuracy: {accuracy:.2f}%")
    


def predict_label(model, test_images, index):
    """
    Predicts the label for a given image in the test set

    INPUT: 
        model - the trained model
        test_images   -  a tensor. test image set of shape Nx1x28x28
        index   -  specific index  i of the image to be tested: 0 <= i <= N - 1


    RETURNS:
        None
    """
    class_names = ['T-shirt/top','Trouser','Pullover','Dress','Coat',
                   'Sandal','Shirt','Sneaker','Bag','Ankle Boot']
    model.eval()
    with torch.no_grad():
        logits = model(test_images[index].unsqueeze(0))
        probabilities = F.softmax(logits, dim=1)[0]
        top3 = torch.argsort(probabilities, descending=True)[:3]
        
        for rank, idx in enumerate(top3):
            print(f"{class_names[idx]}: {probabilities[idx] * 100:.2f}%")


if __name__ == '__main__':
    '''
    Feel free to write your own test code here to exaime the correctness of your functions. 
    Note that this part will not be graded.
    '''
    criterion = nn.CrossEntropyLoss()
    train_loader = get_data_loader()
    test_loader = get_data_loader(training=False)
    
    model = build_model()
    train_model(model, train_loader, criterion, T=5)
    evaluate_model(model, test_loader, criterion)
    
    test_images, _ = next(iter(test_loader))
    predict_label(model, test_images, 1)
