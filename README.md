# Fake-News-Detection-Using-Multivariate-Data-Analysis

This project explores the use of **multivariate statistical techniques** to identify and classify fake news. Using a labeled dataset from Kaggle, we applied **factor analysis**, **multiple regression**, and **logistic regression** to uncover patterns and build predictive models for news authenticity.

---

## 👥 Team Members

- Shanmukh Sri Surya Gopi
- Shiva Kumar Midde
- Srikar Morla
- Kavya Medikonda

---

## 🧠 Objective

To determine whether **multivariate analysis techniques** can effectively distinguish between fake and true news articles based on textual and metadata features.

---

## 🧾 Dataset

- Source: Kaggle
- Two CSV files: `True.csv` and `Fake.csv`
- Fields: `title`, `text`, `subject`, `date`

Total articles:
- ✅ True: 21,417 articles
- ❌ Fake: 23,481 articles

---

## 🧹 Data Preparation

- Removed duplicates
- Created `classification` label (1 = Fake, 0 = True)
- Cleaned and normalized text
- Computed `text_length` for each article

---

## 📊 Exploratory Analysis

- Distribution plots for class and text length
- Descriptive statistics for all key features
- Multivariate assumption checks (pair plots, correlation)

---

## 🔬 Statistical Modeling

### 1. 📉 **Factor Analysis**
- Performed using `CountVectorizer`-based TF matrix
- Revealed latent semantic patterns for true vs. fake articles

### 2. 📈 **Multiple Linear Regression**
- Predicts `text_length` using metadata + classification label
- Result:
  - **R² = 0.001** → Small variance explained
  - **Statistically significant difference** in text length

### 3. ✅ **Logistic Regression**
- Classifies article authenticity
- Used vectorized text as predictor
- Result:
  - **Accuracy = 1.0** on test set
  - **Pseudo R² = 0.001** → Text length alone is weak predictor
  - Statistically significant but practically minimal impact

---

## 📌 Results

| Technique           | Key Result                                    |
|---------------------|-----------------------------------------------|
| Factor Analysis     | Identified latent semantics in fake vs true   |
| Multiple Regression | Fake news ~164 words longer on average        |
| Logistic Regression | Perfect classification, weak single-feature   |

- Mean Squared Error (MSE): 3.341 (low)
- Classification Accuracy (LogReg): 1.0

---

## 🧾 Key Insights

- Fake articles tend to be **longer** than real ones.
- **Textual patterns** can be uncovered using factor loading.
- **Metadata alone is not sufficient** — stronger features needed (author credibility, engagement, NLP semantics).

---

## 🛠️ Tools & Libraries

- Python (pandas, NumPy, sklearn)
- CountVectorizer
- Statsmodels
- Matplotlib, Seaborn
- Jupyter Notebook

---

## 🧠 Recommendations

- Include **additional features** like author credibility, sentiment, or engagement metrics.
- Explore **ensemble models** or **deep learning (LSTM, transformers)** for scalable fake news detection.
- Build a UI for real-time predictions using Flask or Streamlit.

---


