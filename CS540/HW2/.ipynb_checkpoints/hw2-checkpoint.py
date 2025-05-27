import sys
import math


def get_parameter_vectors():
    '''
    This function parses e.txt and s.txt to get the  26-dimensional multinomial
    parameter vector (characters probabilities of English and Spanish) as
    descibed in section 1.2 of the writeup

    Returns: tuple of vectors e and s
    '''
    #Implementing vectors e,s as lists (arrays) of length 26
    #with p[0] being the probability of 'A' and so on
    e=[0]*26
    s=[0]*26

    with open('e.txt',encoding='utf-8') as f:
        for line in f:
            #strip: removes the newline character
            #split: split the string on space character
            char,prob=line.strip().split(" ")
            #ord('E') gives the ASCII (integer) value of character 'E'
            #we then subtract it from 'A' to give array index
            #This way 'A' gets index 0 and 'Z' gets index 25.
            e[ord(char)-ord('A')]=float(prob)
    f.close()

    with open('s.txt',encoding='utf-8') as f:
        for line in f:
            char,prob=line.strip().split(" ")
            s[ord(char)-ord('A')]=float(prob)
    f.close()

    return (e,s)

#1.1
def shred(filename):
    #Using a dictionary here. You may change this to any data structure of
    #your choice such as lists (X=[]) etc. for the assignment
    
    X = {chr(c): 0 for c in range(ord('A'), ord('Z')+1)} #creates a range of numbers [65, 66, ..., 90] for Ascii set to zero
    with open (filename,encoding='utf-8') as f:
        for line in f:
            for ch in line:
                if ch.isalpha():
                    ch = ch.upper()
                    if ch in X:
                        X[ch] += 1

    return X

#1.2
def compute_language_posteriors(X, e, s, prior_eng=0.6, prior_span=0.4):
    """
    calculates the probability that a given text was written in English or Spanish, 
    based on the Bayesian posterior probability formula
    
    X: list of length 26 with the counts for A..Z
    e: list of length 26 with P(A)..P(Z) for English
    s: list of length 26 with P(A)..P(Z) for Spanish
    prior_eng, prior_span: the prior probabilities

    Returns: (post_eng, post_span)
    """
    
    F_english = math.log(prior_eng)
    F_spanish = math.log(prior_span)
    for i in range(26):
        F_english += X_list[i] * math.log(e[i])
        F_spanish += X_list[i] * math.log(s[i])
    
    max_log = max(F_english, F_spanish)
    eng_exp = math.exp(F_english - max_log)
    span_exp = math.exp(F_spanish - max_log)
    p_eng = eng_exp / (eng_exp + span_exp)

    return F_english, F_spanish

#1.3
def robust_posterior(X_list, eng, span, prior_eng=0.6, prior_span=0.4):
    """
    computes the posterior probability, P(English|X) and P(Spanish|X), that a given letter 
    distribution X belongs to English or Spanish using Bayes' Theorem,
    then uses the difference to avoid underflow/overflow

    X_list  : list of length 26 with counts for letters A..Z
    eng  : list of length 26 with p(A..Z) for English
    span  : list of length 26 with p(A..Z) for Spanish
    prior_eng, prior_span : prior probabilities

    Returns: (F_english, F_spanish, post_prob_eng)
    """

    #compute F(English) and F(Spanish)
    F_english = math.log(prior_eng)
    F_spanish = math.log(prior_span)
    
    for i in range(26):
        #add X_list[i]*log(eng[i]) or X_list[i]*log(span[i])
        F_english += X_list[i] * math.log(eng[i])
        F_spanish += X_list[i] * math.log(span[i])

    diff = F_spanish - F_english

    #handle large differences to avoid overflow/underflow
    if diff >= 100:
        # e^(diff) is extremely large -> Spanish dominates -> P(English|X)= 0
        post_prob_eng = 0.0
        post_prob_span = 1.0
    elif diff <= -100:
        # e^(diff) is extremely small -> English dominates -> P(English|X)=1
        post_prob_eng = 1.0
        post_prob_span = 0.0
    else:
        #normal case -> use the logistic form
        ratio = math.exp(diff)
        post_prob_eng = 1.0 / (1.0 + ratio)
        post_prob_span = ratio / (1.0 + ratio)

    return F_english, F_spanish, post_prob_eng

#1.4
if __name__ == "__main__":
    
    #python3 hw2.py samples/letter0.txt 0.6 0.4
    letter_file = sys.argv[1]
    prior_eng = float(sys.argv[2])
    prior_span = float(sys.argv[3])

    # Q1: followed by the 26 character counts for letter.txt.
    X_dict = shred(letter_file)
    print("Q1")
    for c in range(ord('A'), ord('Z')+1):
        ch = chr(c)
        print(ch, X_dict[ch])

    # dict -> list: [count(A), count(B), ..., count(Z)]
    X_list = [X_dict[chr(c)] for c in range(ord('A'), ord('Z')+1)]

    # Q2: compute X1 log(eng1) and X1 log(span1), with X1=counts for 'A'
    eng, span = get_parameter_vectors()
    X1 = X_list[0]
    eng1 = eng[0]
    span1 = span[0]
    
    #check eng1>0, span1>0
    x1_log_e1 = X1 * math.log(eng1) if eng1 > 0 else float('-inf')
    x1_log_s1 = X1 * math.log(span1) if span1 > 0 else float('-inf')
    print("Q2")
    print(f"{x1_log_e1:.4f}")
    print(f"{x1_log_s1:.4f}")

    # Q3: Compute F(English) and F(Spanish)
    F_english, F_spanish, post_prob_eng = robust_posterior(X_list, eng, span, prior_eng, prior_span)
    print("Q3")
    print(f"{F_english:.4f}")
    print(f"{F_spanish:.4f}")

    # Q4: Compute P(English | X)
    print("Q4")
    print(f"{post_prob_eng:.4f}")


# TODO: add your code here for the assignment
# You are free to implement it as you wish!
# Happy Coding!
