ARG POETRY_VERSION=1.1.13
ARG APP_HOME=/usr/app

FROM python:3.9 AS build
ARG POETRY_VERSION
ARG APP_HOME
WORKDIR ${APP_HOME}
RUN pip install "poetry==${POETRY_VERSION}" \
    && python -m venv ${APP_HOME}/venv

COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt | ${APP_HOME}/venv/bin/pip install -r /dev/stdin

COPY src/ ./src
RUN poetry build \
    && ${APP_HOME}/venv/bin/pip install dist/*.whl

FROM python:3.9-alpine@sha256:89ea7c66e4acf3d466a7ba1a3c8cf20895e3d6e69c8f5b0b3ccd6ffaf38075bb AS final
ARG APP_HOME

RUN addgroup -S app && adduser -S -G app app
COPY --chown=app:app --from=build ${APP_HOME}/venv ${APP_HOME}/venv
ENV PATH="${APP_HOME}/venv/bin:${PATH}"

USER app

CMD ["gunicorn", "-b", "0.0.0.0:8000", "echo_server.app:app"]
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD curl -f https://localhost:8000/health

