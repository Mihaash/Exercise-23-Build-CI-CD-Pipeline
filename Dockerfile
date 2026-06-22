FROM python:3.12-slim AS builder

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

FROM python:3.12-alpine

RUN addgroup -S -g 1000 appgroup && \
    adduser -S -u 1000 appuser -G appgroup

WORKDIR /app
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app .

EXPOSE 5000

USER appuser

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
