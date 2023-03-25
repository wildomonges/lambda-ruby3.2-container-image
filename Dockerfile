FROM amazonlinux:2023

# Set ruby version to install
ARG RUBY_VERSION=3.2.1

# Define custom function directory
ARG FUNCTION_DIR="/function"

# Install ruby, bundler and the Runtime Interface Client
RUN dnf install -y ruby \
  && dnf clean all \
  && gem update --system \
  && gem install bundler \
  && gem install aws_lambda_ric

# Set working directory
WORKDIR ${FUNCTION_DIR}

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ${FUNCTION_DIR}/
RUN bundle config set --local deployment 'true' && bundle install

# Copy layer codes
ADD lib ${FUNCTION_DIR}/lib

# Copy lambda function code
COPY hello_world/app.rb ${FUNCTION_DIR}/

# Call lambda runtime
ENTRYPOINT ["/usr/local/bin/aws_lambda_ric"]

#CMD ["app.lambda_handler"]
