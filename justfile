# Project.
PROJECT          := "respline"
SRC_DIR          := "." / "src"
PROJECT_MODULE_DIR := SRC_DIR / PROJECT
VENV             := "." / ".venv"
DOC_DIR          := "." / "doc"
SPHINX_SRC_DIR   := DOC_DIR / "src"
SPHINX_BUILD_DIR := DOC_DIR
SPHINX_API_DIR   := SPHINX_SRC_DIR / "api"

# Tools.
MISE_BIN          := "mise"
MISE_EXEC         := MISE_BIN + " exec -- "
UV_BIN            := MISE_EXEC + "uv "
UV_RUN            := UV_BIN + "run "
RUFF_BIN          := "ruff"
RUFF_FORMAT       := UV_RUN + RUFF_BIN + " format "
RUFF_CHECK        := UV_RUN + RUFF_BIN + " check "
PYLINT_BIN        := "pylint"
PYLINT            := UV_RUN + PYLINT_BIN
SPHINX_BUILD_BIN  := "sphinx-build"
SPHINX_BUILD      := UV_RUN + SPHINX_BUILD_BIN
SPHINX_APIDOC_BIN := "sphinx-apidoc"
SPHINX_APIDOC     := UV_RUN + SPHINX_APIDOC_BIN
PYTEST_BIN        := "pytest"
PYTEST            := UV_RUN + PYTEST_BIN
PRE_COMMIT_BIN    := "pre-commit"
PRE_COMMIT        := UV_RUN + PRE_COMMIT_BIN
PREK_BIN          := "prek"
PREK              := UV_RUN + PREK_BIN

# Configuration.
UV_VENV_OPTS       := "" + \
  " --no-managed-python"
RUFF_FORMAT_OPTS   := "" + \
    " --diff"
RUFF_CHECK_OPTS    := ""
SPHINX_BUILD_OPTS  := ""
SPHINX_APIDOC_OPTS := "" + \
    " -f"
PYTEST_OPTS        := "" + \
    " -v"
PRECOMMIT_RUN_OPTS := "" + \
    " --all-files"
PREK_RUN_OPTS      := "" + \
    " --all-files"


# Put it first so that "make" without argument is like "make help".
[default]
help:
    @echo "Manage splinart development".
    @just --justfile {{ justfile() }} --list

# Create or recreate Python virtual environment ("--dev" option will install dev. tools).
venv DEV="":
    # Remove existing VENV directory if existing.
    [ -e "{{ VENV }}" ] && rm -Rf "{{ VENV }}"
    # Let uv create new virtualenv.
    {{ UV_BIN }} venv {{ UV_VENV_OPTS }}
    # Uv sync project's dependencies in virtualenv.
    @{{ UV_BIN }} sync
    # Uv installs project it-self in virtualenv.
    @if [ "{{ DEV }}" = "--dev" ]; then                  \
        {{ UV_BIN }} pip install --editable ".[dev]" ;  \
    else                                                \
        {{ UV_BIN }} pip install . ;                    \
    fi

# Format Python sources.
fmt target="":
    # ruff format
    @{{ RUFF_FORMAT }} {{ RUFF_FORMAT_OPTS }} {{ target }}

# Lint Python sources.
lint target="":
    # ruff check
    @{{ RUFF_CHECK }} {{ RUFF_CHECK_OPTS }} {{ target }}
    # pylint
    {{ PYLINT }} {{ target }}

# Run tests.
test:
    @{{ PYTEST }} {{ PYTEST_OPTS }}

pre-commit:
    # pre-commit
    #@{{ PRE_COMMIT }} run {{ PRECOMMIT_RUN_OPTS }}
    # prek
    @{{ PREK }} run {{ PREK_RUN_OPTS }}

# Generate HTML documentation through Sphinx.
#doc:
#    @{{ SPHINX_APIDOC }} {{ SPHINX_APIDOC_OPTS }} -o {{ SPHINX_API_DIR }} {{ PROJECT_MODULE_DIR }}
#    @{{ SPHINX_BUILD }} -M html {{ SPHINX_SRC_DIR }} {{ SPHINX_BUILD_DIR }} {{ SPHINX_BUILD_OPTS }}

# List all justfile variables.
vars:
    @just --justfile {{ justfile() }} --evaluate
