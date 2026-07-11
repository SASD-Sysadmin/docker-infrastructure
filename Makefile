.PHONY: validate test catalog smoke readiness manifest
validate:
	./scripts/validate.sh

test:
	bundle exec rake

catalog:
	./scripts/test-catalog.sh

smoke:
	bundle exec rake smoke

readiness:
	./scripts/release-readiness.sh --require-branch main

manifest:
	python3 scripts/generate-release-manifest.py
	python3 scripts/verify-release-manifest.py dist/release-manifest.json
