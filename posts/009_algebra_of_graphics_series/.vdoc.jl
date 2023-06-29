#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
using PalmerPenguins, DataFrames, CSV

penguins = dropmissing(DataFrame(PalmerPenguins.load()))
first(penguins, 6)
#
#
#
#
#
#
#
#
#
#
#
#

using AlgebraOfGraphics, CairoMakie
set_aog_theme!()

axis = (width = 225, height = 225)
penguin_frequency = data(penguins) * frequency() * mapping(:species)

draw(penguin_frequency; axis = axis)

#
#
#
#
#
#
#
#
#

plt = penguin_frequency * mapping(color = :island)
draw(plt; axis = axis)

#
#
#
#
#
#
#
#
#
plt = penguin_frequency * mapping(color = :island, dodge = :island)
draw(plt; axis = axis)

#
#
#
#
#
plt = penguin_frequency * mapping(color = :island, dodge = :sex)
draw(plt; axis = axis)

#
#
#
#
#
plt = penguin_frequency * mapping(color = :island, stack = :island)
draw(plt; axis = axis)
#
#
#
#
#
plt = penguin_frequency * mapping(color = :island, stack = :island, dodge=:sex)
draw(plt; axis = axis)
#
#
#
#
#
penguin_bill = data(penguins) * mapping(:bill_length_mm,:bill_depth_mm)
draw(penguin_bill; axis = axis)
#
#
#
#
#
penguin_bill = data(penguins) * mapping(
    :bill_length_mm => (t -> t / 10) => "bill length (cm)",
    :bill_depth_mm => (t -> t / 10) => "bill depth (cm)",
)
draw(penguin_bill; axis = axis)
#
#
#
#
#
plt = penguin_bill * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
plt = penguin_bill * linear() * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
#
plt = penguin_bill * linear() * mapping(color = :species) + penguin_bill * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
#
plt = penguin_bill * (linear() + mapping()) * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
#
layers = linear() + mapping()
plt = penguin_bill * layers * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
layers = linear() + mapping(marker = :sex)
plt = penguin_bill * layers * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
layers = linear() + mapping(col = :sex)
plt = penguin_bill * layers * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
#
#
layers = linear() + mapping()
plt = penguin_bill * layers * mapping(color = :species, col = :sex)
draw(plt; axis = axis)
#
#
#
#
#
#
#
using AlgebraOfGraphics: density
plt = penguin_bill * density(npoints=50) * mapping(col = :species)
draw(plt; axis = axis)
#
#
#
#
#
plt *= visual(colormap = :grayC, colorrange = (0, 6))
draw(plt; axis = axis)
#
#
#
#
#
axis = (type = Axis3, width = 300, height = 300)
layer = density() * visual(Wireframe, linewidth=0.05)
plt = penguin_bill * layer * mapping(color = :species)
draw(plt; axis = axis)

#
#
#
#
#
#
axis = (width = 225, height = 225)
layer = density() * visual(Contour)
plt = penguin_bill * layer * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
#
layers = density() * visual(Contour) + linear() + mapping()
plt = penguin_bill * layers * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
#
layers = density() * visual(Contour) + linear() + visual(alpha = 0.5)
plt = penguin_bill * layers * mapping(color = :species)
draw(plt; axis = axis)
#
#
#
#
#
body_mass = :body_mass_g => (t -> t / 1000) => "body mass (kg)"
layers = linear() * mapping(group = :species) + mapping(color = body_mass, marker = :species)
plt = penguin_bill * layers
draw(plt; axis = axis)
#
#
#
#
#
#
axis = (type = Axis3, width = 300, height = 300)
plt = penguin_bill * mapping(body_mass, color = :species)
draw(plt; axis = axis)
#
#
#
#
#
plt = penguin_bill * mapping(body_mass, color = :species, layout = :sex)
draw(plt; axis = axis)
#
#
#
#
#
#
#
#| eval: false
using DecisionTree, Random

# use approximately 80% of penguins for training
Random.seed!(1234) # for reproducibility
N = nrow(penguins)
train = fill(false, N)
perm = randperm(N)
train_idxs = perm[1:floor(Int, 0.8N)]
train[train_idxs] .= true

# fit model on training data and make predictions on the whole dataset
X = hcat(penguins.bill_length_mm, penguins.bill_depth_mm)
y = penguins.species
model = DecisionTreeClassifier() # Support-Vector Machine Classifier
fit!(model, X[train, :], y[train])
ŷ = predict(model, X)

# incorporate relevant information in the dataset
penguins.train = train;
penguins.predicted_species = ŷ;


CSV.write("penguins.csv", penguins)
#
#
#
#
#
#

penguins = CSV.read("penguins.csv", DataFrame)
penguin_bill = data(penguins) * mapping(:bill_length_mm,:bill_depth_mm)

axis = (width = 225, height = 225)
dataset =:train => renamer(true => "training", false => "testing") => "Dataset"
accuracy = (:species, :predicted_species) => isequal => "accuracy"
plt = data(penguins) *
    expectation() *
    mapping(:species, accuracy) *
    mapping(col = dataset)
draw(plt; axis = axis)
#
#
#
#
#
error_rate = (:species, :predicted_species) => !isequal => "error rate"
plt = data(penguins) *
    expectation() *
    mapping(:species, error_rate) *
    mapping(col = dataset)
draw(plt; axis = axis)
#
#
#
#
#
prediction = :predicted_species => "predicted species"
datalayer = mapping(color = prediction, row = :species, col = dataset)
plt = penguin_bill * datalayer
draw(plt; axis = axis)
#
#
#
#
#
pdflayer = density() * visual(Contour) * mapping(group = :species, color=:species)
layers = pdflayer + datalayer
plt = penguin_bill * layers
draw(plt; axis = axis)
#
#
#
#
#
#

pdflayer = density() * visual(Contour, colormap=Reverse(:grays)) * mapping(group = :species, row=:species, col = dataset)
layers = pdflayer + datalayer
plt = penguin_bill * layers
draw(plt; axis = axis)
#
#
#
#
#
#

pdflayer = density() * visual(Contour, colormap=Reverse(:grays)) * mapping(group = :species)
layers = pdflayer + datalayer
plt = penguin_bill * layers
draw(plt; axis = axis)
#
#
#
#
#
#
#
#
#
