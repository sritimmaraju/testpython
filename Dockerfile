FROM python:3.8
LABEL name="Sri Timmaraju"

ENV PATH="/tools:${PATH}" \
    ENVIRONMENT="dev" \
    FLASK_DEBUG=True \
    PACKAGES="unzip curl openssl ca-certificates git libc6-dev bash jq gettext make" \
    CF_CLI_VERSION="6.47.2" \
    CF_BGD_VERSION="1.3.0" \
    CF_BGD_CHECKSUM="c74995ae0ba3ec9eded9c2a555e5984ba536d314cf9dc30013c872eb6b9d76b6" \
    CF_BGD_TEMPFILE="/tmp/blue-green-deploy.linux64" \
    CF_AUTOPILOT_VERSION="0.0.4" \
    CF_AUTOPILOT_CHECKSUM="a755f9da3981fb6dc6aa675a55f8fc7de9d73c87b8cad4883d98c543a45a9922" \
    CF_AUTOPILOT_TEMPFILE="/tmp/autopilot-linux" \
    SPRUCE_VERSION="1.22.0"

RUN pip install --upgrade pip && \
    apt-get update && \
    apt-get install $PACKAGES && \
    pip install gitdb2 && \
    pip install cloudfoundry-client && \
    pip install gitpython && \
    pip install pytest && \
    pip install requests && \
    curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&version=${CF_CLI_VERSION}" | tar -zx -C /usr/local/bin && \
    curl -L -o "${CF_BGD_TEMPFILE}" \
    "https://github.com/bluemixgaragelondon/cf-blue-green-deploy/releases/download/v${CF_BGD_VERSION}/blue-green-deploy.linux64" && \
    echo "${CF_BGD_CHECKSUM}  ${CF_BGD_TEMPFILE}" | sha256sum -c - && \
    chmod +x "${CF_BGD_TEMPFILE}" && \
    cf install-plugin -f "${CF_BGD_TEMPFILE}" && \
    rm "${CF_BGD_TEMPFILE}" && \
    curl -L -o "${CF_AUTOPILOT_TEMPFILE}" \
    "https://github.com/contraband/autopilot/releases/download/${CF_AUTOPILOT_VERSION}/autopilot-linux" && \
    echo "${CF_AUTOPILOT_CHECKSUM}  ${CF_AUTOPILOT_TEMPFILE}" | sha256sum -c - && \
    chmod +x "${CF_AUTOPILOT_TEMPFILE}" && \
    cf install-plugin -f "${CF_AUTOPILOT_TEMPFILE}" && \
    rm "${CF_AUTOPILOT_TEMPFILE}" && \
    curl -Lo /usr/local/bin/spruce https://github.com/geofffranks/spruce/releases/download/v${SPRUCE_VERSION}/spruce-linux-amd64 && \
    chmod +x /usr/local/bin/spruce
