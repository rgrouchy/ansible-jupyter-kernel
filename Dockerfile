FROM python:3.8-alpine

# Install dependencies
RUN apk add --no-cache gcc musl-dev libffi-dev openssl-dev make openssh-client

# Set environment variables
ENV LANG=C.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=C.UTF-8 \
    NB_USER=notebook \
    NB_UID=1000 \
    HOME=/home/${NB_USER}

# Create a new user
RUN adduser -D -u ${NB_UID} ${NB_USER}

# Copy files into the container
COPY . ${HOME}

# Change the owner of the home directory to the new user
RUN chown -R ${NB_UID} ${HOME}

# Install Python packages

RUN pip install jupyter_client IPython notebook ansible-jupyter-widgets lxml
RUN pip install --ignore-installed jupyter_client -e ${HOME}/.

# Install the Ansible Jupyter Kernel
RUN python -m ansible_kernel.install

# Switch to the new user
USER ${NB_USER}

# Set the working directory
WORKDIR ${HOME}/notebooks

# Start Jupyter Notebook
CMD ["jupyter-notebook", "--ip", "0.0.0.0"]

# Expose the Jupyter Notebook port
EXPOSE 8888
