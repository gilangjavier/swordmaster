#Install boto3 first = pip install boto3
import boto3

def check_docker_image_in_ecr(repository_name, image_tag):
    # Create a new session
    client = boto3.client('ecr')

    try:
        response = client.describe_images(
            repositoryName=repository_name,
            imageIds=[
                {
                    'imageTag': image_tag
                },
            ]
        )
        # If the image is found, print the details
        if response['imageDetails']:
            print(f"Docker image {image_tag} found in {repository_name}")
            print(response['imageDetails'])
        else:
            print(f"No Docker image {image_tag} found in {repository_name}")

    except Exception as e:
        print(f"Error checking image: {e}")

# Ask the user for the repository name and image tag
repository_name = input("Enter the name of the repository: ")
image_tag = input("Enter the tag of the Docker image: ")

check_docker_image_in_ecr(repository_name, image_tag)