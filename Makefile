
UV := $(shell command -v uv 2> /dev/null)
VENV := .venv
SYSTEM_PYTHON := $(shell command -v python3 2> /dev/null || command -v python 2> /dev/null)
REQUIREMENTS := requirements.txt
MAIN_FILE := add_function.py
TEST_MAIN_FILE := test_add_function.py
ifeq ($(OS), Windows_NT)
	VENV_BIN := $(VENV)/Scripts
else
	VENV_BIN := $(VENV)/bin
endif
ifdef UV
	RUN_CMD := uv run
	PYTHON_CMD := $(RUN_CMD) python
	SETUP_CMD := uv init . && uv venv
	INSTALL_CMD := uv add -r $(REQUIREMENTS)
else
	PYTHON_CMD := $(VENV_BIN)/python
	RUN_CMD := $(PYTHON_CMD) -m
	PIP_CMD := $(RUN_CMD) pip
	SETUP_CMD := $(SYSTEM_PYTHON) -m venv $(VENV)
	INSTALL_CMD := $(PIP_CMD) install --upgrade pip && $(PIP_CMD) install -r $(REQUIREMENTS)
endif
.PHONY: install test lint all setup clean
setup:
	@echo "Checking setup..."
	@if [ ! -d "$(VENV)" ]; then $(SETUP_CMD); fi

install: setup
	@echo "Installing dependencies..."
	$(INSTALL_CMD)
format:
	@echo "Formating.."
	$(RUN_CMD) black $(MAIN_FILE) $(TEST_MAIN_FILE)
test:
	@echo "Running tests..."
	$(RUN_CMD) pytest -vv --junitxml=test-results.xml --cov=add_function $(TEST_MAIN_FILE)
lint:
	@echo "Running lint..."
	$(RUN_CMD) pylint --disable=R,C $(MAIN_FILE)

clean:
	@echo "Cleaning..."
	rm -rf $(VENV) .pytest_cache .coverage __pycache__

all: install format lint test
