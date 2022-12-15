# torc-assesment

This script assumes that user is going to input, the same wording in by the user meaning that the names of the product items does not change if the user changes in the input. The script does not read what the user input
To run the file just download the REPO and run ruby torc_assesment.rb
To run the spec file you an run rspec torc_assesment_spec.rb

Things that can be improved
- If i had more tie I would add the two methods into a Tax class which class methods no need to have instance methods I think, that can reduce the repeated code in rspec
- Also I would make the calculation dynamic depending on the user input, one way to to it if we only inputed this products then, we could use the word "bottle" with regex to deduce that all name with the word "bottle" in it would be added salex tax and we could use the word "imported" as a flag for ingported tax but they were super risky and didnt feel it was most important
