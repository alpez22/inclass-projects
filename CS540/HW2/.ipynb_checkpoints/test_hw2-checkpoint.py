import sys
import hw2
import math

def read_Q1_output(filename):
    expected_counts = {}
    with open(filename, encoding='utf-8') as f:
        lines = f.readlines()
    
    start_index = lines.index("Q1\n") + 1  # Find the line after "Q1"
    for i in range(start_index, start_index + 26):  # Read 26 letters
        letter, count = lines[i].strip().split()
        expected_counts[letter] = int(count)
    
    return expected_counts


def read_Q2_output(filename):
    with open(filename, encoding='utf-8') as f:
        lines = f.readlines()
    
    start_index = lines.index("Q2\n") + 1  # Find Q2 section
    log_priors = [float(lines[start_index].strip()), float(lines[start_index + 1].strip())]
    
    return log_priors


def read_Q3_output(filename):
    with open(filename, encoding='utf-8') as f:
        lines = f.readlines()
    
    start_index = lines.index("Q3\n") + 1  # Find Q3 section
    log_likelihoods = [float(lines[start_index].strip()), float(lines[start_index + 1].strip())]
    
    return log_likelihoods


def read_Q4_output(filename):
    with open(filename, encoding='utf-8') as f:
        lines = f.readlines()
    
    start_index = lines.index("Q4\n") + 1  # Find Q4 section
    posterior_prob = float(lines[start_index].strip())  # Single value
    
    return posterior_prob


def test_shred():
    passed = True
    for i in range(5): #iterate over letter0.txt to letter4.txt
        input_file = f"samples/letter{i}.txt"
        output_file = f"samples/letter{i}_out.txt"
        
        result = hw2.shred(input_file)
        
        #expected output per letterX.txt
        expected = read_Q1_output(output_file)
        
        if result == expected:
            print(f"Test {i} PASSED ✅")
        else:
            print(f"Test {i} FAILED ❌")
            print("Expected:")
            for k, v in expected.items():
                print(f"{k} {v}")
            print("Got:")
            for k, v in result.items():
                print(f"{k} {v}")
            passed = False
    
    if passed:
        print("\nAll tests passed!")
    else:
        print("\nSome tests failed. Check differences above.")

def test_language_identification(input_file, expected_output_file, prior_eng=0.6, prior_span=0.4):
    """
    Tests Section 1.2: Bayesian Language Identification.

    Steps:
    1. Read the letter frequency counts (Q1).
    2. Compute log-likelihoods for English and Spanish (Q3).
    3. Compute posterior probability for English (Q4).
    4. Compare with expected values from test_output.txt.
    """
    #get the count vector X from the shredded file
    X = hw2.shred(input_file)
    
    #convert dictionary to list representation
    X_vector = [X[chr(i)] for i in range(ord('A'), ord('Z') + 1)]
    
    #load the parameter vectors for English & Spanish
    e, s = hw2.get_parameter_vectors()

    #compute log-likelihoods
    log_eng = math.log(prior_eng) + sum(X_vector[i] * math.log(e[i]) for i in range(26))
    log_span = math.log(prior_span) + sum(X_vector[i] * math.log(s[i]) for i in range(26))

    #compute posterior probability using exponentiation trick
    max_log = max(log_eng, log_span)
    eng_exp = math.exp(log_eng - max_log)
    span_exp = math.exp(log_span - max_log)
    posterior_eng = eng_exp / (eng_exp + span_exp)

    #read expected values from test_output.txt
    expected_q1 = read_Q1_output(expected_output_file)
    expected_q3 = read_Q3_output(expected_output_file)
    expected_q4 = read_Q4_output(expected_output_file)

    #compare results
    print("\nTEST RESULTS for", input_file)

    #check letter counts (Q1)
    if X == expected_q1:
        print("✅ Q1: Letter counts match!")
    else:
        print("❌ Q1: Letter counts mismatch!")
        print("Expected:", expected_q1)
        print("Got:", X)

    #check log-likelihoods (Q3)
    if math.isclose(log_eng, expected_q3[0], abs_tol=0.01) and math.isclose(log_span, expected_q3[1], abs_tol=0.01):
        print("✅ Q3: Log-likelihoods match!")
    else:
        print("❌ Q3: Log-likelihoods mismatch!")
        print(f"Expected: English {expected_q3[0]}, Spanish {expected_q3[1]}")
        print(f"Got: English {log_eng}, Spanish {log_span}")

    #check posterior probability (Q4)
    if math.isclose(posterior_eng, expected_q4, abs_tol=0.01):
        print("✅ Q4: Posterior probability matches!")
    else:
        print("❌ Q4: Posterior probability mismatch!")
        print(f"Expected: {expected_q4}")
        print(f"Got: {posterior_eng}")

def test_language_identification_robust(input_file, expected_output_file, prior_eng=0.6, prior_span=0.4):
    """
    Similar to test_language_identification, but uses hw2.robust_posterior
    to test the numerically stable log-sum difference approach.
    """
    #shred the input to get letter counts
    X_dict = hw2.shred(input_file)

    #convert to list [X_A, X_B, ..., X_Z]
    X_list = [X_dict[chr(i)] for i in range(ord('A'), ord('Z') + 1)]

    #load e, s
    e, s = hw2.get_parameter_vectors()

    #call robust_posterior
    F_english, F_spanish, posterior_eng = hw2.robust_posterior(X_list, e, s, prior_eng, prior_span)

    #read EXPECTED values from the output file
    expected_q1 = read_Q1_output(expected_output_file)  # letter counts
    expected_q3 = read_Q3_output(expected_output_file)  # [F_english, F_spanish]
    expected_q4 = read_Q4_output(expected_output_file)  # single float

    print("\nROBUST TEST RESULTS for", input_file)

    #compare Q1
    if X_dict == expected_q1:
        print("✅ Q1: Letter counts match!")
    else:
        print("❌ Q1: Letter counts mismatch!")
        print("Expected:", expected_q1)
        print("Got:", X_dict)

    # compare Q3 = log-likelihood sums
    #   expected_q3[0] => F_english (expected)
    #   expected_q3[1] => F_spanish (expected)
    fe_ok = math.isclose(F_english, expected_q3[0], abs_tol=0.01)
    fs_ok = math.isclose(F_spanish, expected_q3[1], abs_tol=0.01)
    if fe_ok and fs_ok:
        print("✅ Q3: Log-likelihood sums match!")
    else:
        print("❌ Q3: Mismatch in F(English) or F(Spanish)!")
        print(f"Expected: Eng={expected_q3[0]}, Span={expected_q3[1]}")
        print(f"Got: Eng={F_english}, Span={F_spanish}")

    # compare Q4 = posterior_eng
    if math.isclose(posterior_eng, expected_q4, abs_tol=0.01):
        print("✅ Q4: Posterior probability matches!")
    else:
        print("❌ Q4: Posterior mismatch!")
        print(f"Expected: {expected_q4}")
        print(f"Got: {posterior_eng}")


if __name__ == "__main__":
    test_shred()
    for i in range(5):
        test_language_identification(
            input_file=f"samples/letter{i}.txt",
            expected_output_file=f"samples/letter{i}_out.txt"
        )
    for i in range(5):
        test_language_identification_robust(
            input_file=f"samples/letter{i}.txt",
            expected_output_file=f"samples/letter{i}_out.txt"
        )
    