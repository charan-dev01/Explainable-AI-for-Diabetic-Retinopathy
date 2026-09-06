# Explainable AI for Diabetic Retinopathy Screening

An explainable deep-learning based system for **Diabetic Retinopathy (DR) screening from retinal fundus photographs**, designed with a focus on transparency, clinical interpretability, and telemedicine deployment.

The system classifies retinal fundus images into **five stages of Diabetic Retinopathy** and provides visual explanations using **Grad-CAM**, while separate lesion-segmentation models provide additional evidence for retinal abnormalities such as microaneurysms, hemorrhages, and exudates.

The project is designed as a prototype for scalable DR screening, particularly for **rural and resource-constrained healthcare environments**.

---

## 📌 Project Overview

Diabetic Retinopathy is a diabetes-related eye disease that can lead to vision loss if it is not detected and treated early. Screening large populations using manual examination of retinal images can be time-consuming and requires trained ophthalmologists.

Our system uses **deep learning-based image analysis** to assist in screening fundus photographs.

Instead of treating the AI classifier as a black box, the system provides an explanation of **which regions of the retinal image contributed to the predicted DR classification**.

### Core Pipeline

```text
                    Fundus Photograph
                           │
                           ▼
                ┌─────────────────────┐
                │ Image Quality Check │
                │ + Enhancement       │
                └──────────┬──────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
      DR Classification          Lesion Segmentation
              │                         │
              ▼                         ▼
       DR Grade 0–4             Lesion Evidence
       + Confidence          ┌──────────┼──────────┐
                             ▼          ▼          ▼
                         Microaneurysm Hemorrhage Exudate
              │                         │
              └────────────┬────────────┘
                           ▼
                    Explainability
                           │
                  ┌────────┴────────┐
                  ▼                 ▼
               Grad-CAM        Evidence Report
                  │                 │
                  └────────┬────────┘
                           ▼
                  Referable DR Decision
                           │
                           ▼
                      MATLAB UI
                           │
                           ▼
                       Simulink
                  Telemedicine Model
```

---

# 🎯 Objectives

The primary objectives of this project are:

* Automatically classify Diabetic Retinopathy severity from fundus photographs.
* Provide a **5-class DR classification** from No DR to Proliferative DR.
* Generate visual explanations using **Grad-CAM**.
* Identify retinal regions that contributed to the classifier's prediction.
* Provide additional lesion-level evidence using separate segmentation models.
* Estimate prediction confidence.
* Generate a simple patient-level explainability report.
* Demonstrate a telemedicine workflow using **MATLAB/Simulink**.
* Explore the scalability of AI-assisted screening for large patient populations.
* Keep classification explanations and lesion segmentation as **independent complementary evidence sources**.

---

# 🧠 Deep Learning Models

## 1. DR Classification Model

A trained deep-learning image classification model is used to classify fundus photographs into five DR severity levels:

| Class | DR Grade                |
| ----: | ----------------------- |
|     0 | No Diabetic Retinopathy |
|     1 | Mild DR                 |
|     2 | Moderate DR             |
|     3 | Severe DR               |
|     4 | Proliferative DR        |

The classifier produces:

```text
Predicted Class
Predicted DR Grade
Class Probabilities
Confidence Score
```

The existing trained classifier is used directly during inference.

**The classifier is not retrained as part of the explainability pipeline.**

---

# 🔍 Explainable AI

## Grad-CAM

To make the DR classifier more interpretable, the system uses **Gradient-weighted Class Activation Mapping (Grad-CAM)**.

Grad-CAM uses gradients flowing into a selected convolutional feature layer to determine which spatial regions contributed most strongly to the model's prediction.

### Grad-CAM Pipeline

```text
Fundus Image
     │
     ▼
DR Classifier
     │
     ▼
Predicted DR Class
     │
     ▼
Selected Convolutional Layer
     │
     ▼
Feature Maps + Gradients
     │
     ▼
Global Average of Gradients
     │
     ▼
Feature Map Weighting
     │
     ▼
Weighted Feature Maps
     │
     ▼
ReLU
     │
     ▼
Normalized Heatmap
     │
     ▼
Overlay on Fundus Image
```

The Grad-CAM implementation uses **TensorFlow GradientTape**.

The convolutional feature layer is selected automatically by inspecting the model architecture rather than assuming a particular layer name.

This also allows the implementation to handle models containing nested CNN backbones such as architectures based on EfficientNet.

---

# 🔬 Lesion-Level Evidence

Grad-CAM and lesion segmentation serve different purposes in the system.

Separate segmentation models are used to provide evidence for:

* **Microaneurysms**
* **Hemorrhages**
* **Exudates**
* **Retinal vessels**

The lesion segmentation models produce masks identifying the corresponding retinal structures or abnormalities.

### Important Design Principle

Grad-CAM is **not used to generate lesion masks**.

Instead:

```text
                    Fundus Image
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
     DR Classifier                Lesion Models
          │                             │
          ▼                             ▼
      Grad-CAM                    Segmentation Masks
          │                             │
          ▼                             ▼
 Regions influencing             Lesion-specific
   classification                   evidence
```

These two methods are presented as **complementary explanation sources** rather than mathematically combining their outputs.

A highlighted Grad-CAM region should therefore **not automatically be interpreted as a confirmed lesion**.

---

# 🩺 Explainability Report

The system generates a patient-level report containing:

```text
DR Grade: Moderate
Predicted Class: 2

Confidence: 87%

Referable DR: YES

Evidence:
✓ Microaneurysms detected
✓ Hemorrhages detected
✓ Exudates detected

Explanation:
Grad-CAM highlights retinal regions that
contributed strongly to the classifier's
prediction.

Recommendation:
Refer to ophthalmologist.
```

The report combines:

1. DR classifier prediction
2. Prediction confidence
3. Grad-CAM visualization
4. Lesion segmentation evidence
5. Referable DR decision
6. Suggested referral action

---

# 🚨 Referable DR

For the prototype, the system can derive a **referable DR decision** from the predicted DR severity/probability.

The output structure is designed as:

```json
{
    "dr_grade": 0,
    "referable_probability": 0.0,
    "referable": false,
    "lesion_evidence": {
        "microaneurysm": false,
        "hemorrhage": false,
        "exudate": false
    },
    "vessel_mask": "...",
    "gradcam": "...",
    "confidence": 0.0,
    "report": "..."
}
```

The exact referral threshold should be treated as a **prototype/system-design parameter**, not as a clinically validated diagnostic threshold.

---

# 🖼️ Grad-CAM Outputs

For each input fundus photograph, the explainability pipeline generates:

### Original Image

The original fundus photograph supplied to the classifier.

### Grad-CAM Heatmap

A heatmap representing the regions contributing to the predicted class.

### Grad-CAM Overlay

The Grad-CAM heatmap overlaid on the original fundus image.

### Numerical Heatmap

The normalized Grad-CAM activation map is also saved as a NumPy array.

```text
original.png
gradcam_heatmap.png
gradcam_overlay.png
gradcam_heatmap.npy
```

---

# 🛠️ Technologies Used

## Programming Languages

* Python
* MATLAB

## Deep Learning

* TensorFlow
* Keras

## Explainable AI

* Grad-CAM
* TensorFlow `GradientTape`

## Image Processing

* NumPy
* Pillow
* Matplotlib
* MATLAB Image Processing Toolbox

## Simulation

* MATLAB
* Simulink

## Development Environment

* Kaggle Notebooks
* MATLAB

---

# 🧩 System Architecture

The complete prototype consists of several independent modules.

```text
┌─────────────────────────────────────────────┐
│                INPUT FUNDUS                 │
│              RGB Photograph                │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
              Image Quality Check
                       │
                       ▼
                 Enhancement
                       │
            ┌──────────┴──────────┐
            │                     │
            ▼                     ▼
      DR Classifier        Lesion/Vessel Models
            │                     │
            ▼                     ▼
       DR Grade              Lesion Masks
       Confidence                  │
            │                      │
            ▼                      │
         Grad-CAM                  │
            │                      │
            └──────────┬───────────┘
                       ▼
                Explainability
                    Report
                       │
                       ▼
               Referable Decision
                       │
                       ▼
                  MATLAB UI
                       │
                       ▼
                   Simulink
                       │
                       ▼
              Telemedicine Workflow
```

---

# 📊 Telemedicine Simulation

A simplified telemedicine workflow is modeled using **Simulink**.

```text
Rural Camera
     │
     ▼
Image Acquisition
     │
     ▼
Quality Check
     │
     ▼
AI Screening
     │
     ▼
Explainability
     │
     ▼
Remote Ophthalmologist
     │
     ▼
Referral
```

The simulation considers parameters such as:

* Patients per day
* Image acquisition time
* AI inference time
* Network bandwidth
* Transmission delay
* Ophthalmologist review capacity
* Queue length
* Waiting time
* Referral workload
* System throughput

---

# 📈 Scalability Target

The prototype explores whether an AI-assisted screening workflow can support screening at a scale of **100,000+ patients per year**.

For reference:

```text
100,000 patients / 365 days
≈ 274 patients/day
```

The Simulink model can therefore be used to evaluate whether the simulated workflow can handle approximately **274 patients per day** under different system configurations.

---

# 📁 Repository Structure

A suggested repository structure is:

```text
Explainable-AI-DR/
│
├── README.md
│
├── python/
│   ├── gradcam.py
│   ├── model_inspection.py
│   └── requirements.txt
│
├── matlab/
│   ├── preprocessing/
│   ├── explainability/
│   ├── report_generation/
│   └── ui/
│
├── simulink/
│   ├── telemedicine_model.slx
│   └── simulation_parameters.m
│
├── outputs/
│   ├── original.png
│   ├── gradcam_heatmap.png
│   ├── gradcam_overlay.png
│   └── gradcam_heatmap.npy
│
├── sample_images/
│
└── docs/
    ├── architecture.png
    └── system_workflow.png
```

---

# 🔄 End-to-End Workflow

The system processes a fundus image through the following stages:

### 1. Image Acquisition

A retinal fundus photograph is obtained from a camera or imaging device.

### 2. Image Quality Assessment

The image is checked for quality issues such as insufficient visibility or unsuitable input.

### 3. Image Enhancement

Image-processing techniques are applied where required to improve the quality of the retinal photograph.

### 4. DR Classification

The trained classifier predicts one of five DR grades.

### 5. Confidence Estimation

The class probabilities are used to obtain the model's prediction confidence.

### 6. Grad-CAM Explanation

Grad-CAM identifies regions that contributed to the predicted DR class.

### 7. Lesion Analysis

Independent segmentation models identify retinal lesions and structures.

### 8. Evidence Presentation

Classifier output, Grad-CAM visualization, and lesion evidence are presented together.

### 9. Referral Decision

A prototype referable/non-referable decision is generated.

### 10. Telemedicine Simulation

The complete workflow is evaluated in Simulink under different patient loads and system constraints.

---

# ⚠️ Important Interpretation

Grad-CAM provides **model attribution**, not a medical diagnosis.

A highlighted region means:

> "This region contributed strongly to the model's prediction."

It does **not** necessarily mean:

> "This region contains a confirmed diabetic-retinopathy lesion."

Lesion segmentation provides separate lesion-specific evidence.

Therefore, the system intentionally keeps:

```text
Grad-CAM
   ≠
Lesion Segmentation
```

They are complementary explanations.

---

# 🎯 Key Features

* 5-class Diabetic Retinopathy classification
* Automated model architecture inspection
* Automatic Grad-CAM convolutional-layer selection
* Gradient-based visual explanations
* Fundus image heatmap generation
* Original/heatmap/overlay visualization
* Numerical Grad-CAM output
* Prediction confidence
* Lesion-level evidence
* Patient-level explainability report
* Referable DR decision
* MATLAB integration
* Simulink telemedicine simulation
* Scalability analysis for 100,000+ patients/year

---

# 🚀 Future Improvements

Possible future extensions include:

* Better image-quality assessment
* Lesion-aware explainability
* Uncertainty and confidence calibration
* Multi-model ensemble classification
* More robust retinal lesion segmentation
* Clinical validation on larger datasets
* Real-time deployment on edge devices
* Low-bandwidth image transmission
* Integration with telemedicine platforms
* Prospective clinical evaluation

---

# ⚕️ Disclaimer

This project is a **research/hackathon prototype** intended to demonstrate AI-assisted diabetic retinopathy screening and explainability.

It is **not a medical diagnostic device** and should not be used as a substitute for examination or diagnosis by a qualified ophthalmologist.

The Grad-CAM visualizations represent model attribution and should not be interpreted as definitive lesion localization.

---

# 👥 Project Contributions

The project is divided into modular components:

### DR Classification

Development and integration of the trained DR classification model.

### Lesion & Vessel Analysis

Development/integration of segmentation models for retinal lesions and vessels.

### Explainability & System Simulation

* Grad-CAM implementation
* Model interpretability
* Explainability report generation
* Evidence presentation
* MATLAB integration
* Simulink telemedicine workflow
* Scalability simulation

---

# 🌟 Project Goal

The ultimate goal is to demonstrate how **AI-based retinal screening can be made more transparent and deployable**, allowing healthcare professionals to see not only the predicted DR severity but also the visual and lesion-level evidence associated with the prediction.

```text
                    AI Screening
                         │
                         ▼
                 Prediction
                         │
                         ▼
                  Explanation
                         │
            ┌────────────┴────────────┐
            ▼                         ▼
        Grad-CAM                Lesion Evidence
            │                         │
            └────────────┬────────────┘
                         ▼
                  Human Review
                         │
                         ▼
              Better-informed referral
```

**Explainable AI for more transparent and scalable diabetic retinopathy screening.**
