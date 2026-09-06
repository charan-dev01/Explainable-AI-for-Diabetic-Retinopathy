# Team CodeStorm
# Rural DR Screening — MATLAB Prototype

This is a corrected research-stage prototype assembled from the uploaded ONNX models and MATLAB code. It is designed as a human-in-the-loop screening workflow, not a clinically cleared autonomous diagnostic device.

## Pipeline

1. Image quality gate: focus, exposure, contrast, illumination variation, and fundus field-of-view coverage.
2. Borderline enhancement: illumination normalization + CLAHE + light denoising.
3. 5-class DR grading: No DR / Mild / Moderate / Severe / Proliferative DR.
4. Referable DR: grade >= 2 with configurable threshold (default 0.40 from the supplied configuration).
5. Lesion evidence: microaneurysm, hemorrhage, and exudate ONNX models at 256x256.
6. Retinal structures: optic-disc/fovea localization heuristic and vessel segmentation fallback.
7. Explainability: Grad-CAM when the imported classifier exposes a usable convolutional feature layer; lesion masks are shown as explicit evidence rather than being mislabeled as Grad-CAM.
8. Calibration: optional temperature scaling learned on a validation set.
9. Report: annotated PNG + JSON + TXT with a review-oriented summary.
10. Capacity simulation: acquisition bandwidth, inference throughput, reviewer capacity, queue growth, and annual planning.

## Important correction to the uploaded implementation

The uploaded scripts used filenames such as `aptos_dr_classifier_matlab.onnx` and `microaneurysm_model.onnx`, while the uploaded files had suffixed names. This prototype normalizes the model filenames inside `models/` and all code references those normalized names.

The supplied lesion runner also imported each model on every call. This prototype caches imports and validates output shape. The prior code also printed hemorrhage diagnostics for every lesion type; that is corrected.

## Requirements

MATLAB R2023b+ is recommended, with Image Processing Toolbox, Deep Learning Toolbox, Computer Vision Toolbox, Statistics and Machine Learning Toolbox, and Simulink. Medical Imaging Toolbox is optional for extensions.

## Run

From this folder in MATLAB:

```matlab
setupPrototype
main_DR_Screening
```

The main script lets an operator select an image, gates quality, enhances borderline images, runs DR grading and lesion evidence, generates an annotated report, and stores outputs under `results/`.

## Validation

Use `validateAptosDataset` after placing an APTOS-style `train.csv` next to `train_images/`. The validator computes a confusion matrix and referable-DR sensitivity/specificity on the labeled images. It does **not** invent a clinical claim from the uploaded model. You should report the measured confidence interval, patient-level split strategy, image quality exclusions, and external validation set.

## Online datasets to use

- APTOS 2019 for the 5-grade DR task.
- IDRiD for image-level grading plus pixel-level MA/EX/HE and optic-disc/fovea annotations.
- Messidor-2 and EyePACS can be added as external/heterogeneous validation sources.

Dataset access terms and licenses must be followed at download time. The code does not silently download proprietary or gated datasets.

## Simulink

`simulink/buildScreeningWorkflowModel.m` creates a planning-level Simulink model. `simulateScreeningCapacity.m` is the numerically explicit discrete-time simulator used for sensitivity studies and is also usable without Simulink.

## Clinical limitation

The requested >90% sensitivity and >85% specificity are acceptance targets, not results established by this repository. They must be demonstrated on a locked, patient-independent, externally validated test set with pre-specified thresholds and confidence intervals.

## R2026a fixes

If MATLAB R2026a reports `Invalid value for 'Outputs' argument` during Grad-CAM, use the supplied `computeGradCAM.m`. It first uses MATLAB's native `gradCAM` implementation and its manual fallback supplies `Outputs` as character vectors, matching the `dlnetwork.forward` contract.

If `labeloverlay` reports `Size of input image matrices must agree`, use the supplied `buildAnnotatedReport.m`. Lesion masks are generated at 256x256 and are resized with nearest-neighbour interpolation to the displayed fundus-image size before overlay.

Grad-CAM is allowed to remain unavailable when the imported ONNX graph does not expose a usable feature/reduction path. The report explicitly states this rather than substituting lesion masks and calling them Grad-CAM.
