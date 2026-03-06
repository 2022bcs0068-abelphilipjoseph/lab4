# Lab 4: Automated Model Deployment Using GitHub Actions (CI/CD)

**Student Name:** Abel Philip Joseph
**Roll Number:** 2022bcs0068

## Objective
[cite_start]This repository automates the entire machine learning model deployment workflow using GitHub Actions[cite: 3, 4]. [cite_start]It implements a Continuous Integration and Continuous Deployment (CI/CD) pipeline that automatically trains a model [cite: 31, 33][cite_start], evaluates it against a baseline [cite: 44][cite_start], and, if improved, containerizes and deploys the FastAPI inference service to Docker Hub[cite: 6, 7].

## Deliverable Links
* **GitHub Repository:** [https://github.com/2022bcs0068-abelphilipjoseph/lab4](https://github.com/2022bcs0068-abelphilipjoseph/lab4)
* **Docker Hub Repository:** [https://hub.docker.com/repositories/iiitkabel](https://hub.docker.com/repositories/iiitkabel)

---

## CI/CD Pipeline Architecture

The workflow consists of two main jobs triggered on a push to the repository:

### 1. Continuous Integration (Train Job)
* [cite_start]Sets up the Python 3.11 environment on an Ubuntu runner[cite: 32].
* [cite_start]Executes the training script (`scripts/train.py`) to train a new model[cite: 33].
* [cite_start]Captures the evaluation metrics and saves them to `metrics.json`[cite: 35, 36, 37].
* [cite_start]Uploads the trained model and metrics as a GitHub Artifact for the deployment phase[cite: 38].

### 2. Continuous Deployment (Deploy Job)
* [cite_start]Checks success of the train job using `needs: train`[cite: 41].
* [cite_start]Downloads the model artifacts generated in the CI job[cite: 42].
* [cite_start]**Metric Comparison:** Compares the newly trained model's current metric against the `BEST_Metric` variable stored in GitHub[cite: 43, 44].
  * [cite_start]*If metrics do not improve:* The job terminates and outputs `<2022bcs0068:>----Metric did not improve`[cite: 45].
  * [cite_start]*If metrics improve:* Proceeds to build the Docker image[cite: 48].
* [cite_start]Logs into Docker Hub using configured secrets (`DOCKER_USERNAME` and `DOCKER_TOKEN`)[cite: 50].
* [cite_start]Builds the image using the `Dockerfile` and pushes the FastAPI container image to Docker Hub so it can be pulled by servers[cite: 51, 53].
* [cite_start]Updates the `Best Metrics` GitHub Variable to the new high score to set a harder target to beat for future runs[cite: 56].

---

## Post-Deployment Validation

[cite_start]To verify the deployment locally, you can pull the published image and run inference[cite: 58].

### 1. Pull the Image
```bash
docker pull iiitkabel/wine-model:latest
```

### 2. Run the Container
```bash
docker run -d -p 8000:8000 iiitkabel/wine-model:latest
```

### 3. Perform Inference
Send a POST request to the prediction endpoint:
```bash
curl -X POST "http://localhost:8000/predict" \
     -H "Content-Type: application/json" \
     -d '{"fixed_acidity": 7.4, "volatile_acidity": 0.7, "citric_acid": 0, "residual_sugar": 1.9, "chlorides": 0.076, "free_sulfur_dioxide": 11, "total_sulfur_dioxide": 34, "density": 0.9978, "pH": 3.51, "sulphates": 0.56, "alcohol": 9.4}'
```

### 4. Expected Response
[cite_start]The API returns the prediction in the following format[cite: 63, 64]:
```json
{
  "name": "Abel Philip Joseph",
  "roll_no": "2022bcs0068",
  "wine_quality": 5
}
```
