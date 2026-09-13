# Model provenance and limitations

| File | Intended role | Provenance status | Limitations |
|---|---|---|---|
| `models/aptos_dr_classifier.onnx` | Five-class DR image classifier | Unverified from files alone; filename suggests APTOS, but no training card, license, architecture, or dataset split was supplied | Must not be described as validated until independently tested on locked patient-level data. |
| `models/microaneurysm_model.onnx` | MA segmentation map | Unverified | Output semantics and calibration need validation against lesion masks. |
| `models/hemorrhage_model.onnx` | Hemorrhage segmentation map | Unverified | No verified dot/blot/flame labels or performance evidence. |
| `models/exudate_model.onnx` | Exudate segmentation map | Unverified | Supports localization only when map output imports successfully. |

All ONNX files use the preprocessing encoded in `prototypeConfig.json`: classifier 224×224 RGB with ImageNet-style normalization; lesions 256×256 RGB in [0,1]. The pipeline identifies an import failure and marks the fallback as non-model evidence; it does not claim validation or regulatory status.
