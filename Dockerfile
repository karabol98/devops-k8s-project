# Χρησιμοποιούμε μια ελαφριά έκδοση της Python
FROM python:3.9-slim

# Ορίζουμε τον φάκελο εργασίας μέσα στο container
WORKDIR /app

# Αντιγράφουμε τα requirements και τα εγκαθιστούμε
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Αντιγράφουμε τον υπόλοιπο κώδικα
COPY . .

# Ανοίγουμε την πόρτα 5000
EXPOSE 5000

# Η εντολή για να τρέξει η εφαρμογή
CMD ["python", "app.py"]