RUN R -e "install.packages('tsmp',dependencies=TRUE, repos='http://cran.rstudio.com/')"

LABEL maintainer="sebastian.schmidl@hpi.de"

ENV ALGORITHM_MAIN="/app/algorithm.r"

COPY . /app/
