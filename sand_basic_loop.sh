## Sandra Hanekamp, basic loop 
## First, create a list of all the subjects that you have (## in your other script use ${SUBJ} to run the participant)
for subj in HC01 HC02 GL01 GL02; do

## a message that you would like to display in the terminal while running the code
    echo 'Working very hard for:' ${subj}

## the path to the code that you want to run
    bash /N/dc2/projects/lifebid/Sandra/path/to/shell/script/sand_mrtrix_wholebrain.sh ${subj}
done

## then run this script by cd to code folder, and bash sand_basic_loop.sh



