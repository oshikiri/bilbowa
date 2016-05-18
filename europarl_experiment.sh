#!/bin/bash
set -e


mkdir corpus
cd corpus
wget http://www.statmt.org/europarl/v7/es-en.tgz
tar zxvf es-en.tgz
wget http://www.statmt.org/europarl/v7/tools.tgz
tar zxvf tools.tgz
cd -
 
./corpus/tools/tokenizer.perl -l es < ./corpus/europarl-v7.es-en.es | awk '{print tolower($0)}' | awk 'NR <= 500000' > ./corpus/europarl-v7.es-en.es.tokenized.500000
./corpus/tools/tokenizer.perl -l en < ./corpus/europarl-v7.es-en.en | awk '{print tolower($0)}' | awk 'NR <= 500000' > ./corpus/europarl-v7.es-en.en.tokenized.500000

bash compile.sh

# These setting of tuning parameters are described at
#   https://www.reddit.com/r/MachineLearning/comments/40odr8/bilbowa_fast_bilingual_distributed/cywhsgj
time ./bin/bilbowa \
    -par-train1  ./corpus/europarl-v7.es-en.es.tokenized.500000 \
    -par-train2  ./corpus/europarl-v7.es-en.en.tokenized.500000 \
    -mono-train1 ./corpus/europarl-v7.es-en.es.tokenized.500000 \
    -mono-train2 ./corpus/europarl-v7.es-en.en.tokenized.500000 \
    -output1 vectors_bilbowa_es-en_es.txt \
    -output2 vectors_bilbowa_es-en_en.txt \
    -size 40 \
    -window 20 \
    -sample 1e-5 \
    -negative 10 \
    -binary 0 \
    -min-count 1 \
    -threads 1
