[System]
Name='fuzzyrules'
Type='mamdani'
Version=2.0
NumInputs=3
NumOutputs=1
NumRules=3
AndMethod='min'
OrMethod='max'
ImpMethod='min'
AggMethod='max'
DefuzzMethod='centroid'

[Input1]
Name='input1'
Range=[0 1]
NumMFs=3
MF1='len1':'trimf',[-0.1 0 0.1]
MF2='len2':'trimf',[0.96 0.98 1]
MF3='col':'trimf',[0.99 1 1.1]

[Input2]
Name='input2'
Range=[0 1]
NumMFs=3
MF1='wid1':'trimf',[0.2 0.3 0.4]
MF2='wid2':'trimf',[0.4 0.55 0.7]
MF3='wid3':'trimf',[0.9 1 1.1]

[Input3]
Name='input3'
Range=[0 1]
NumMFs=3
MF1='col1':'trimf',[0.88 0.89 0.9]
MF2='col2':'trimf',[0.95 1 1.05]
MF3='col3':'trimf',[0.85 0.9 0.95]

[Output1]
Name='output1'
Range=[0 1]
NumMFs=3
MF1='blast':'trimf',[-0.4 0 0.4]
MF2='Brownspot':'trimf',[0.1 0.5 0.9]
MF3='Narrowbs':'trimf',[0.6 1 1.4]

[Rules]
1 1 1, 1 (1) : 1
2 2 2, 2 (1) : 1
3 3 3, 3 (1) : 1
