# This file is for use as a devcontainer and a runtime container
#
# The devcontainer should use the developer target and run as root with podman
# or docker with user namespaces.
FROM python:3.11 as developer
# Add any system dependencies for the developer/build environment here e.g.
# RUN apt-get update && apt-get upgrade -y && \
#     apt-get install -y --no-install-recommends \
#     desired-packages \
#     && rm -rf /var/lib/apt/lists/*
RUN python -m venv /venv
ENV PATH=/venv/bin:$PATH

# The build stage installs the context into the venv
FROM developer as build
COPY . /context
WORKDIR /context
RUN pip install .

# The runtime stage copies the built venv into a slim runtime container
FROM python:3.11-slim as runtime
# Add apt-get system dependecies for runtime here if needed
COPY --from=build /venv/ /venv/
ENV PATH=/venv/bin:$PATH

# change this entrypoint if it is not the same as the repo
ENTRYPOINT ["copier-example"]
CMD ["--version"]
