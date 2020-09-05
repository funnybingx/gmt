#!/usr/bin/env bash
# Test gmt convert -Td<select> option to skip duplicates
cat << EOF > data.txt
0	0	4.46031835138	0.275015041826	AAA
1	1	4.5705316237	2.1778079668	BBB
1	1	1.92499958767	2.41849793467	BBB
1	1	3.46806994568	2.69478794313	CCC
4	4	3.46806994568	2.69478794313	DDD
5	5	1.45537732935	0.237260430696	DDD
5	5	0.526774435084	2.63605870895	AAA
5	7	4.71711448613	4.23872130655	EEE
8	8	3.46806994568	0.188999134204	AAA
9	9	3.46806994568	2.69478794313	AAA
EOF
# 1. Eliminate duplicated x-values
gmt convert data.txt -Td0 > result.1
cat << EOF > answer.1
0	0	4.46031835138	0.275015041826	AAA
1	1	4.5705316237	2.1778079668	BBB
4	4	3.46806994568	2.69478794313	DDD
5	5	1.45537732935	0.237260430696	DDD
8	8	3.46806994568	0.188999134204	AAA
9	9	3.46806994568	2.69478794313	AAA
EOF
# 2. Eliminate duplicated x/y-values
gmt convert data.txt -Td0:1 > result.2
cat << EOF > answer.2
0	0	4.46031835138	0.275015041826	AAA
1	1	4.5705316237	2.1778079668	BBB
4	4	3.46806994568	2.69478794313	DDD
5	5	1.45537732935	0.237260430696	DDD
5	7	4.71711448613	4.23872130655	EEE
8	8	3.46806994568	0.188999134204	AAA
9	9	3.46806994568	2.69478794313	AAA
EOF
# 3. Eliminate repeated z-values
gmt convert data.txt -Td2 > result.3
cat << EOF > answer.3
0	0	4.46031835138	0.275015041826	AAA
1	1	4.5705316237	2.1778079668	BBB
1	1	1.92499958767	2.41849793467	BBB
1	1	3.46806994568	2.69478794313	CCC
5	5	1.45537732935	0.237260430696	DDD
5	5	0.526774435084	2.63605870895	AAA
5	7	4.71711448613	4.23872130655	EEE
8	8	3.46806994568	0.188999134204	AAA
EOF
# 4. Eliminate repeated values in cols 2 and 3
gmt convert data.txt -Td2,3 > result.4
cat << EOF > answer.4
0	0	4.46031835138	0.275015041826	AAA
1	1	4.5705316237	2.1778079668	BBB
1	1	1.92499958767	2.41849793467	BBB
1	1	3.46806994568	2.69478794313	CCC
5	5	1.45537732935	0.237260430696	DDD
5	5	0.526774435084	2.63605870895	AAA
5	7	4.71711448613	4.23872130655	EEE
8	8	3.46806994568	0.188999134204	AAA
9	9	3.46806994568	2.69478794313	AAA
EOF
# 5. Eliminate duplicate record solely on the basis of trailing text
gmt convert data.txt -Tdt > result.5
cat << EOF > answer.5
0	0	4.46031835138	0.275015041826	AAA
1	1	4.5705316237	2.1778079668	BBB
1	1	3.46806994568	2.69478794313	CCC
4	4	3.46806994568	2.69478794313	DDD
5	5	0.526774435084	2.63605870895	AAA
5	7	4.71711448613	4.23872130655	EEE
8	8	3.46806994568	0.188999134204	AAA
EOF
# 6. Eliminate duplicate record defined by col 2 and trailing text
gmt convert data.txt -Td2,t > result.6
cat << EOF > answer.6
0	0	4.46031835138	0.275015041826	AAA
1	1	4.5705316237	2.1778079668	BBB
1	1	1.92499958767	2.41849793467	BBB
1	1	3.46806994568	2.69478794313	CCC
4	4	3.46806994568	2.69478794313	DDD
5	5	1.45537732935	0.237260430696	DDD
5	5	0.526774435084	2.63605870895	AAA
5	7	4.71711448613	4.23872130655	EEE
8	8	3.46806994568	0.188999134204	AAA
EOF
# Look for differences between results and truth
diff result.1 answer.1 --strip-trailing-cr  > fail
diff result.2 answer.2 --strip-trailing-cr >> fail
diff result.3 answer.3 --strip-trailing-cr >> fail
diff result.4 answer.4 --strip-trailing-cr >> fail
diff result.5 answer.5 --strip-trailing-cr >> fail
diff result.6 answer.6 --strip-trailing-cr >> fail
