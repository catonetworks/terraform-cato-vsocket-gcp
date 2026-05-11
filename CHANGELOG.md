# Changelog

## 0.0.1 (2025-01-31)

### Features
- Initial commit with single socket instance with 3 NICs 
- Added default values for required parameters

## 0.0.2 (2025-02-13)

### Features
- Added support for tags and labels

## 0.0.3 (2025-02-14)

### Features
- Updated image path to new vsocket image

## 0.0.7 (2025-05-07)

### Features
- Added optional license resource and inputs used for commercial site deployments

## 0.0.8 (2025-05-15)

### Features
- Removed VM name using site_name to name vsocket instance to align with module design for all clouds, removed validation for optional variables which default to null.

## 0.0.9 (2025-09-04)

### Features
- Fixed issue with private IP, added readme examples to show how to configure

## 0.0.10 (2025-09-22)

### Features
- Updated outputs to include instance_id, and removed legacy reference to vm_instance_self_link

## 0.0.11 (2026-05-07)

### Features
- Updated minimum cato provider version requirement to version 0.0.73
- Added `region` variable for GCP region input with format validation
- Added automatic site location resolution from GCP region using a new hardcoded mapping
- Mapping covers all major GCP regions across North America, Canada, Europe, Asia Pacific (including Australia and India), Middle East, Africa, and South America
- Eliminates the need to manually specify `site_location` for supported GCP regions
- User-provided `site_location` values still take precedence over the auto-resolved defaults
