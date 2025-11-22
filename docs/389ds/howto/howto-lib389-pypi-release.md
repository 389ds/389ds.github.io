---
title: "How to lib389 PyPI Release"
---

# How to lib389 PyPI Release
-----------------------------
{% include toc.md %}

### Important Notes

- lib389 should be released **AFTER** the Fedora release process is complete
- lib389 version **MUST** match the 389-ds-base version that was released to Fedora
- Ideally, release lib389 in the same state it was released in Fedora packages

### Prerequisites

- PyPI account at https://pypi.org/account/register/
	- You will need maintainer access to the lib389 project
	- Create API tokens at Account Settings → API tokens

- TestPyPI account at https://test.pypi.org/account/register/ (for testing)

- Install required tools

		pip install --upgrade pip build twine

- Configure `~/.pypirc` with API tokens

		[pypi]
		username = __token__
		password = pypi-YOUR_PRODUCTION_TOKEN_HERE

		[testpypi]
		username = __token__
		password = pypi-YOUR_TEST_TOKEN_HERE

		chmod 600 ~/.pypirc


### Validate Version

lib389 version must match the main 389-ds-base version in **VERSION.sh**

	cd src/lib389
	python3 validate_version.py

If version mismatch, update it

	python3 validate_version.py --update


### Run Tests (Optional but Recommended)

Run basic and CLI test suites

	cd /home/$USER/source/ds389/389-ds-base
	pytest dirsrvtests/tests/suites/basic
	pytest dirsrvtests/tests/suites/clu

- Note: Full lib389 test suite is currently not working properly, skip it


### Build Package

Clean previous builds

	cd src/lib389
	rm -rf dist/ build/ *.egg-info

Build distribution packages

	python3 -m build

Verify the build output

	ls -lh dist/
	# Should show: lib389-X.Y.Z.tar.gz and lib389-X.Y.Z-py3-none-any.whl

Check package validity

	python3 -m twine check dist/*


### Test Package Locally

Create test environment and install

	python3 -m venv /tmp/lib389-test
	source /tmp/lib389-test/bin/activate
	pip install dist/lib389-*.whl

Verify installation

	pip show lib389
    python3 -c "import lib389; print('Import OK')"
	dsconf --help

Cleanup

	deactivate
	rm -rf /tmp/lib389-test


### Upload to TestPyPI

Always test on TestPyPI first

	cd src/lib389
	python3 -m twine upload --repository testpypi dist/*

Verify at https://test.pypi.org/project/lib389/

Test installation from TestPyPI

	python3 -m venv /tmp/testpypi-env
	source /tmp/testpypi-env/bin/activate
	pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ lib389
    python3 -c "import lib389; print('Import OK')"
	deactivate
	rm -rf /tmp/testpypi-env


### Upload to Production PyPI

Final checks:
- TestPyPI upload successful
- Version is correct
- Tests pass
- Git repository clean

Upload to PyPI

	cd src/lib389
	python3 -m twine upload --repository pypi dist/*

Verify at https://pypi.org/project/lib389/

Test installation from PyPI

	python3 -m venv /tmp/pypi-test
	source /tmp/pypi-test/bin/activate
	pip install lib389==X.Y.Z
	pip show lib389
	dsconf --help
	deactivate
	rm -rf /tmp/pypi-test


### Announce Release

Send email to these lists with Subject: **Announcing lib389 #.#.# PyPI Release**

- <389-announce@lists.fedoraproject.org>
- <389-users@lists.fedoraproject.org>


### Troubleshooting

**"File already exists"** - PyPI does not allow replacing versions. Increment version and rebuild.

**"Invalid authentication credentials"** - Check `~/.pypirc` has correct tokens and permissions.

**"Package validation failed"** - Run `python3 -m twine check dist/*` to identify metadata issues.

**Yank a release** (if needed) - Go to PyPI project page → Options → Yank release. Then release fixed version.

