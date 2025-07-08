/* Load necessary packages */
proc import datafile="\\apporto.com\dfs\STVN\Users\sgopi_stvn\AppData\Fake.csv" out=fake dbms=csv replace; run;
proc import datafile="\\apporto.com\dfs\STVN\Users\sgopi_stvn\AppData\True.csv" out=true dbms=csv replace; run;

/* Display first few rows of fake news dataset */
proc print data=fake(obs=5); run;

/* Display first few rows of true news dataset */
proc print data=true(obs=5); run;

/* Summary of fake news dataset */
proc contents data=fake; run;

/* Summary of true news dataset */
proc contents data=true; run;

/* Describe fake news dataset */
proc means data=fake; run;

/* Describe true news dataset */
proc means data=true; run;

/* Check variables in fake news dataset */
proc contents data=fake varnum; run;

/* Check variables in true news dataset */
proc contents data=true varnum; run;

/* Check for duplicate values in fake news dataset */
proc sort data=fake out=fake_nodup nodupkey; by _all_; run;

/* Check for duplicate values in true news dataset */
proc sort data=true out=true_nodup nodupkey; by _all_; run;

/* Create a new column identifying real and fake news */
data true; set true_nodup; category = 0; run;
data fake; set fake_nodup; category = 1; run;

/* Combine datasets */
data news; set true fake; run;

/* Remove punctuations */
data news; set news; text = prxchange('s/[-,\.!?]//', -1, text); run;

/* Convert text data to lower case */
data news; set news; text = lowcase(text); run;

/* Concatenate subject and date */
data news; set news; text_subject_date = catx(' ', subject, date); run;

/* Count plot for class distribution */
proc sgplot data=news;
    vbar category / response=category group=category datalabel datalabelattrs=(size=12);
    title 'Class Distribution';
    xaxis label='Category (0=Real, 1=Fake)';
    yaxis label='Count';
run;

/* Calculate text lengths */
data news; set news; text_length = length(text); run;

/* Plot distribution of text lengths */
proc sgplot data=news;
    histogram text_length / fillattrs=(color=cx999999) group=category;
    density text_length / group=category type=kernel;
    xaxis label='Text Length';
    yaxis label='Count';
run;

/* Check multivariate assumptions */
proc corr data=news;
    var text_length category;
    with text_length category;
    scatterplot text_length*category / markerattrs=(symbol=circlefilled);
    density text_length / type=kernel;
run;

/* Vectorize text data */
proc textdata data=news;
    transform text_subject_date / 
        textvector= (out=vector outvocab=vocab);
    run;

/* Perform Factor Analysis */
proc factor data=vector outstat=factor_out;
    var _textvector1-_textvector1000;
    run;

/*the category based on other variables */
proc glmselect data=news outdesign=design noprint;
    class subject;
    model category = subject text_length / selection=none;
    run;

/* Split data into training and testing sets */
proc surveyselect data=news method=srs out=outseed seed=42
    sampsize=(keep=0.8 method=urs) outall;
    run;

data train test; set outseed; 
    if selected=1 then output train;
    else output test;
run;

/* Vectorizing text data */
proc textdata data=train;
    transform text_subject_date / 
        textvector= (out=train_vector outvocab=train_vocab);
    run;

proc textdata data=test;
    transform text_subject_date / 
        textvector= (out=test_vector outvocab=test_vocab);
    run;

/* Linear Regression */
proc reg data=train_vector outest=outest_model;
    model category = textvector1-textvector5000 text_length;
    run;

/* Logistic Regression */
proc logistic data=train_vector plots(only)=(effect);
    model category(event='1') = textvector1-textvector5000 text_length / clparm=wald;
    score data=test_vector out=out_predicted;
    run;
