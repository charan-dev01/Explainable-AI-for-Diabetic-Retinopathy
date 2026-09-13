# LUMORA VISION
### Explainable AI–Assisted Diabetic Retinopathy Screening

**LUMORA VISION** is a MATLAB-based clinical decision-support prototype for diabetic retinopathy (DR) screening from retinal fundus photographs. It combines automated image-quality assessment, DR grading, confidence estimation, lesion-level evidence, retinal structure analysis, Grad-CAM explainability, macular screening, clinician review, report generation, and a telemedicine workflow.

> **Research / prototype notice:** LUMORA VISION is intended for research, demonstration, and clinician decision-support workflow development. It is **not a medical diagnostic device** and does not replace examination or diagnosis by a qualified ophthalmologist.

---

## Demo

A demonstration of the project is available here:

**https://youtu.be/-zfdNnzEZ3Q**

---

## What LUMORA VISION Does

The current application is organized around a clinician-facing workflow:

```text
Fundus Image
     │
     ▼
Image Selection & Case Intake
     │
     ▼
Image Gradeability / Quality Gate
     │
     ├──────────────► Recapture / Review guidance when required
     │
     ▼
Image Processing / Grading Image
     │
     ├──────────────────────┐
     ▼                      ▼
DR Classification       Lesion / Structure Analysis
     │                      │
     ▼                      ├── Microaneurysm
DR Grade + Probability     ├── Hemorrhage
+ Confidence               ├── Exudate
     │                      └── Retinal vessels / structures
     │
     ├──────────────┐
     ▼              ▼
Grad-CAM       Macular Screening
     │              │
     └──────┬───────┘
            ▼
   Evidence Workspace
            │
            ▼
 Clinical Decision Support
            │
            ├── Referable probability
            ├── Recommended action
            ├── Anatomical context
            └── Clinician notes
            │
            ▼
      Evidence Report
            │
            ▼
      Clinician Review
            │
            ▼
   Telemedicine / Capacity Simulation
```

The application is designed so that the AI prediction is presented together with **supporting visual and lesion-level evidence**, rather than as an unexplained classification.

---

# Key Features

## 1. Case Intake

The interface provides a structured case-intake area for:

- Case ID
- Eye laterality
- Capture date/time
- Camera/device information
- Reviewer status
- Fundus image selection

The current UI also displays an overall assessment-readiness indicator so that the workflow can move from automated processing toward clinician review.

---

## 2. Image Gradeability

Before clinical interpretation, the selected fundus photograph passes through an image-quality / gradeability stage.

The UI exposes:

- **Gradeability status**
- **Gradeability score**
- Quality-gating information
- Guidance for handling images that are not suitable for reliable screening

This creates an explicit quality gate rather than forcing every image through the downstream screening pipeline.

---

## 3. Five-Class DR Screening

The integrated classifier supports five diabetic retinopathy severity classes:

| Grade | Classification |
|---:|---|
| 0 | No Diabetic Retinopathy |
| 1 | Mild DR |
| 2 | Moderate DR |
| 3 | Severe DR |
| 4 | Proliferative DR |

The screening result can include:

- DR screening grade
- Class probability information
- AI confidence
- Referable probability
- Prototype referral / action recommendation

The classification output is intended as **decision support for clinician confirmation**.

---

# Current Clinical Result Panel

The current LUMORA VISION UI presents the principal screening outputs together in a dedicated **Clinical Result • Screening Decision Support** section.

It includes:

### DR Screening Grade
The predicted DR severity category.

### Referable Probability
A probability-style output used by the prototype's screening decision logic.

### AI Confidence
The model's confidence associated with the screening result.

### Macular Screen
A separate indication of whether macular involvement was detected by the current workflow.

### Recommended Action
A concise workflow recommendation such as routine follow-up or referral-oriented review, depending on the screening result and configured decision logic.

> Referral thresholds and screening recommendations in this prototype should be treated as system-design parameters until clinically validated.

---

# Explainable AI

## Grad-CAM

LUMORA VISION uses **Gradient-weighted Class Activation Mapping (Grad-CAM)** to visualize image regions that contributed to the classifier's prediction.

The conceptual process is:

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
Selected Convolutional Feature Layer
     │
     ▼
Feature Maps + Gradients
     │
     ▼
Gradient-Based Weighting
     │
     ▼
Weighted Feature Maps
     │
     ▼
ReLU + Normalization
     │
     ▼
Grad-CAM Heatmap
     │
     ▼
Overlay on Fundus Image
```

The implementation uses TensorFlow `GradientTape` and inspects the supplied model architecture to locate a suitable convolutional feature layer rather than relying on one hard-coded layer name.

This supports models containing nested CNN backbones, including architectures with EfficientNet-style components.

---

# Evidence Workspace

The current UI contains an **Image Evidence Workspace** where different evidence views can be inspected.

Available views include:

- **Original**
- **Grading image**
- **Structure overlay**
- **Lesion evidence**
- **Grad-CAM**

The evidence workspace also supports an adjustable overlay opacity and provides a visual legend for the displayed evidence.

The purpose is to let a clinician move between the original image, processed image, anatomical structures, lesion evidence, and model-attention visualization without treating any single visualization as a diagnosis.

---

# Lesion-Level Evidence

LUMORA VISION uses independent lesion / structure analysis to provide additional evidence.

The current workflow includes evidence categories such as:

- **Microaneurysms**
- **Hemorrhages**
- **Exudates**
- **Retinal vessels / anatomical structures**

The UI provides a dedicated **Lesion Evidence** panel with a structured evidence table. Detected findings can be selected and highlighted in the evidence workspace.

## Important Design Principle

Grad-CAM and lesion segmentation have different meanings:

```text
                  Fundus Image
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
       DR Classifier        Lesion Models
             │                   │
             ▼                   ▼
         Grad-CAM          Segmentation Masks
             │                   │
             ▼                   ▼
     Model-attribution       Lesion-specific
         evidence               evidence
```

**Grad-CAM is not used to generate lesion masks.**

A highlighted Grad-CAM region means that the region contributed to the model's prediction. It should **not automatically be interpreted as a confirmed retinal lesion**.

Lesion segmentation provides separate lesion-specific evidence.

---

# Anatomical Context & Clinician Notes

The current interface includes an **Anatomical Context & Clinician Notes** section.

The anatomical context area can display information such as:

- Vessel-density information
- Neovascularization screening status
- Macular context

The clinician-notes field is explicitly separated from the AI inference pathway so that reviewer observations can be recorded without being used as input to the AI inference.

---

# Screening Decision Support

The application is designed around **AI-assisted screening decision support**, not autonomous diagnosis.

A simplified output structure is:

```text
Case information
       │
       ▼
Image gradeability
       │
       ▼
DR grade
       │
       ├── AI confidence
       ├── Referable probability
       ├── Macular screen
       ├── Lesion evidence
       ├── Anatomical context
       └── Grad-CAM
       │
       ▼
Recommended action
       │
       ▼
Clinician confirmation
```

The interface explicitly communicates that **clinician confirmation is required**.

---

# Reports

LUMORA VISION supports generation and opening of an evidence-oriented screening report.

The current UI provides:

- **Generate Report**
- **Open Report**
- Patient/case-level screening information
- Model and evidence outputs
- Visual evidence
- Screening decision support information

The report-generation workflow is implemented through the project's MATLAB reporting functions.

---

# MATLAB Application

The integrated GUI is launched with:

```matlab
app = DRScreeningApp;
```

The application brings the major screening functions together into a single clinician-facing workflow.

The main application flow is:

1. Select a fundus image.
2. Enter or confirm case information.
3. Check image gradeability.
4. Run AI assessment.
5. Review DR screening grade.
6. Review referable probability and AI confidence.
7. Inspect lesion and anatomical evidence.
8. Inspect original, grading, structure, lesion, and Grad-CAM views.
9. Review macular screening status.
10. Add clinician notes if required.
11. Generate or open the evidence report.
12. Complete clinician review.

---

# Main MATLAB Components

The repository contains modular MATLAB components corresponding to the screening workflow.

| File | Purpose |
|---|---|
| `DRScreeningApp.m` | Main clinician-facing MATLAB application |
| `main_DR_Screening.m` | Main / scripted screening workflow |
| `screenFundusImage.m` | Integrated screening entry point |
| `checkImageQuality.m` | Fundus-image quality / gradeability assessment |
| `runlesionModel.m` | Lesion-model inference |
| `segmentRetinalStructures.m` | Retinal structure / vessel segmentation |
| `assessMacularInvolvement.m` | Macular involvement screening |
| `gradeDiabetesRetinopathyViaRules.m` | Rule-based evidence / screening grading logic |
| `computeGradCAM.m` | Grad-CAM computation |
| `buildAnnotatedReport.m` | Annotated evidence / report generation |
| `loadONNXModelCached.m` | Cached ONNX model loading |
| `runTelemedicineWorkflow.m` | Telemedicine / capacity workflow |
| `simulateScreeningCapacity.m` | Screening-capacity simulation |
| `comparePipelineAblations.m` | Pipeline ablation planning / comparison |
| `createClinicianEvaluationForm.m` | Clinician evaluation form generation |
| `prototypeConfig.json` | Prototype configuration |
| `DRProcessor.prj` | MATLAB project file |

---

# Integrated Entry Point

`screenFundusImage` is the central integrated processing entry point.

Conceptually, it connects:

```text
Input image
    │
    ├── Quality gate
    ├── DR classification
    ├── Lesion evidence
    ├── Anatomical evidence
    ├── Macular screening
    ├── Confidence / probability outputs
    ├── Grad-CAM
    ├── Rule-based audit information
    └── Report generation
             │
             ▼
       Structured result
```

The evidence-rule grade and classifier grade can be retained independently so that disagreement is visible for clinician review rather than silently hidden.

---

# Model Handling

The project uses supplied trained models for inference.

The screening pipeline is designed to load the available ONNX / deep-learning models and use them directly during inference.

**The explainability pipeline does not retrain the DR classifier.**

Model provenance should be documented separately for any deployment or formal evaluation. Supplied model files should not be treated as clinically validated merely because they can be executed successfully.

---

# Telemedicine Workflow

The project also demonstrates how AI-assisted retinal screening could fit into a telemedicine workflow using MATLAB / Simulink.

```text
Rural / Community Camera
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

The simulation can be used to study operational constraints such as:

- Patients per day
- Image acquisition time
- AI inference time
- Network bandwidth
- Transmission delay
- Ophthalmologist review capacity
- Queue length
- Waiting time
- Referral workload
- System throughput

For district-capacity planning without opening Simulink:

```matlab
runTelemedicineWorkflow
```

To include the supplied Simulink queue-replay workflow:

```matlab
runTelemedicineWorkflow('UseSimulink', true)
```

---

# Screening Capacity

The prototype explores scalability for populations of **100,000+ patients per year**.

For a simple reference point:

```text
100,000 patients / 365 days
≈ 274 patients/day
```

The telemedicine simulation can therefore be used to investigate whether different combinations of acquisition, inference, network, and clinician-review capacity can support approximately 274 patients per day.

This is a **simulation target**, not a claim of real-world clinical throughput.

---

# Additional Evaluation Workflows

The repository also contains supporting evaluation utilities.

## Temperature Scaling

```matlab
calibrateTemperatureScaling(logits, labels, 'OutputFile', ...)
```

This fits a scalar temperature using held-out validation logits. A fitted temperature should only be copied into production configuration after the validation split and calibration procedure have been documented.

## Dataset Validation

```matlab
validateScreeningDataset(imageDir, labelsTable)
```

This can produce a five-class confusion matrix and referable sensitivity/specificity when a real labeled dataset is supplied.

The evaluation cannot produce meaningful dataset-level performance results without an appropriate labeled dataset.

## Clinician Evaluation

```matlab
createClinicianEvaluationForm('clinician_feedback.csv')
```

Creates an empty clinician / ophthalmologist review form for structured feedback.

## Pipeline Ablations

```matlab
comparePipelineAblations(imageDir, labelsTable)
```

Records or supports a common-dataset ablation workflow. It intentionally does not fabricate evaluation results when data are unavailable.

---

# Repository Structure

The current repository is organized around MATLAB application code, screening modules, configuration, documentation, and supporting presentation material.

```text
LUMORA-VISION/
│
├── README.md
├── CONTRIBUTORS
├── README
│
├── DRProcessor.prj
├── DRScreeningApp.m
├── main_DR_Screening.m
├── prototypeConfig.json
│
├── screenFundusImage.m
├── checkImageQuality.m
├── gradeDiabetesRetinopathyViaRules.m
├── runlesionModel.m
├── segmentRetinalStructures.m
├── assessMacularInvolvement.m
├── computeGradCAM.m
│
├── loadONNXModelCached.m
├── buildAnnotatedReport.m
│
├── runTelemedicineWorkflow.m
├── simulateScreeningCapacity.m
│
├── comparePipelineAblations.m
├── createClinicianEvaluationForm.m
│
├── LumoraVision SIH.pptx
│
└── docs / outputs / model files
    └── as supplied or generated by the project workflow
```

> The exact model and output directories may vary with the local project setup.

---

# Technologies

## Programming

- MATLAB
- Python

## Deep Learning

- TensorFlow
- Keras
- ONNX model inference

## Explainable AI

- Grad-CAM
- TensorFlow `GradientTape`

## Image Processing

- MATLAB Image Processing Toolbox
- NumPy
- Pillow
- Matplotlib

## Simulation

- MATLAB
- Simulink

## Development

- MATLAB
- Kaggle Notebooks

---

# End-to-End Example

A typical operator session looks like this:

```text
1. Create / load case
        │
2. Select right or left fundus image
        │
3. Confirm capture information
        │
4. Run AI assessment
        │
5. Gradeability check
        │
6. DR screening classification
        │
7. Confidence + referable probability
        │
8. Lesion evidence
        │
9. Anatomical context
        │
10. Macular screening
        │
11. Grad-CAM visualization
        │
12. Clinician review
        │
13. Generate / open report
        │
14. Continue to telemedicine workflow if required
```

---

# Interpreting the Evidence

LUMORA VISION intentionally separates different types of evidence.

### Classifier output
Answers:

> **What DR class did the model predict?**

### AI confidence / probability
Answers:

> **How strongly does the model support its screening output?**

### Grad-CAM
Answers:

> **Which image regions contributed to the model's prediction?**

### Lesion segmentation
Answers:

> **Where did the lesion-specific models identify candidate abnormalities?**

### Anatomical context
Provides additional structural information for review.

These outputs should be considered **complementary**, not interchangeable.

In particular:

```text
Grad-CAM
   ≠
Confirmed lesion
```

and

```text
AI screening result
   ≠
Final medical diagnosis
```

---

# Clinical Safety and Limitations

This prototype has several important limitations:

- It has not been established as a medical diagnostic device.
- Model performance depends on the training data, supplied model, image quality, and deployment conditions.
- A high AI confidence score does not guarantee clinical correctness.
- Grad-CAM is an attribution method, not definitive lesion localization.
- Lesion segmentation outputs are model-generated evidence and require clinical interpretation.
- Referral thresholds should not be assumed to be clinically validated.
- Dataset-level sensitivity, specificity, calibration, and generalization must be evaluated on appropriate independent clinical datasets before deployment.
- Human / ophthalmologist review remains part of the intended workflow.

---

# Future Development

Potential next steps include:

- Stronger image-quality assessment and recapture guidance
- More robust lesion segmentation
- Improved uncertainty and probability calibration
- Lesion-aware explainability
- Multi-model / ensemble screening
- Independent clinical validation
- Prospective evaluation
- Real-time or edge-device deployment
- Low-bandwidth telemedicine transmission
- Integration with clinical / telemedicine platforms
- Expanded clinician feedback collection
- More extensive capacity and queue simulations

---

# Project Goal

The goal of LUMORA VISION is to demonstrate a **transparent, evidence-oriented, and scalable AI-assisted retinal screening workflow**.

Instead of presenting only a DR prediction, the system brings together:

```text
                 AI Screening
                      │
                      ▼
                  DR Result
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
      Confidence   Grad-CAM   Lesion Evidence
          │           │           │
          └───────────┼───────────┘
                      ▼
              Anatomical Context
                      │
                      ▼
             Clinician Review
                      │
                      ▼
             Screening Action
                      │
                      ▼
               Evidence Report
```

The intended outcome is **better-informed clinician review**, while keeping the distinction between model prediction, model attribution, lesion evidence, and clinical diagnosis explicit.

---

## Disclaimer

**LUMORA VISION is a research / hackathon prototype for AI-assisted diabetic retinopathy screening and explainability. It is not a medical diagnostic device and should not be used as a substitute for examination or diagnosis by a qualified healthcare professional.**

All clinical decisions must be made by appropriately qualified clinicians using the complete clinical context.

---

## Project Credits

The project is modular and includes work across:

- DR classification
- Image quality and preprocessing
- Lesion and vessel analysis
- Macular screening
- Explainable AI / Grad-CAM
- Clinical evidence presentation
- MATLAB application development
- Report generation
- Telemedicine workflow modeling
- Screening-capacity simulation
- Clinician evaluation

---

**LUMORA VISION — Explainable AI for more transparent and scalable diabetic retinopathy screening.**

