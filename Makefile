.PHONY: gen gen-assets gen-tokens

# Generate icon + illustration Dart code and update pubspec.yaml
gen-assets:
	python3 tool/generate_assets.py

# Generate design token Dart files from master_token.json
gen-tokens:
	python3 tool/generate_tokens.py

# Run all generators
gen: gen-tokens gen-assets
