FROM python:3


WORKDIR /app


ADD requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


ADD app.py /app/app.py


EXPOSE 8080


CMD ["python", "app.py"]
