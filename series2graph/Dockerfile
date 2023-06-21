FROM registry.gitlab.hpi.de/akita/i/python3-base:0.2.5

LABEL maintainer="ntng@hvl.no"

ENV ALGORITHM_MAIN="/app/algorithm.py"

COPY requirements.txt /app/
RUN pip install -r requirements.txt

COPY algorithm.py /app/
