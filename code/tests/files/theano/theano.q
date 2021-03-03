// code/tests/files/theano/theano.q - Theano test files
// Copyright (c) 2021 Kx Systems Inc

\d .automl

// @kind function
// @category models
// @desc Fit model on training data and score using test data
// @param data  {dictionary} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} seed used for initialising the same model
// @param mname {symbol} name of the model being applied
// @return      {int|float|boolean} the predicted values for a given model as applied to input data
models.theano.fitScore:{[data;seed;mname]
  dataDict:`xtrain`ytrain`xtest`ytest!raze data;
  mdl:get[".automl.models.theano.",string[mname],".model"][dataDict;seed];
  mdl:get[".automl.models.theano.",string[mname],".fit"][dataDict;mdl];
  get[".automl.models.theano.",string[mname],".predict"][dataDict;mdl]
  }

// @kind function
// @category models
// @desc Compile a theano model for binary problems
// @param data  {dictionary} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param seed  {int} seed used for initialising the same model
// @return      {<} the compiled theano models
models.theano.NN.model:{[data;seed]
  data[`ytrain]:models.i.npArray flip value .ml.i.oneHot data[`ytrain];
  models.theano.buildModel[models.i.npArray data`xtrain;data`ytrain;seed]
  }

// @kind function
// @category models
// @desc Fit a vanilla theano model to data
// @param data  {dictionary} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param mdl   {<} model object being passed through the system (compiled/fitted)
// @return      {<} a vanilla fitted theano model
models.theano.NN.fit:{[data;mdl]
  data[`ytrain]:models.i.npArray flip value .ml.i.oneHot data[`ytrain];
  mdls:.p.wrap each mdl`;
  trainMdl:first mdls;
  models.theano.trainModel[models.i.npArray data`xtrain;data`ytrain;trainMdl];
  last mdls
  }

// @kind function
// @category models
// @desc Predict test data values using a compiled model
//  for binary problem types
// @param data  {dictionary} containing training and testing data according to keys
//   `xtrn`ytrn`xtst`ytst
// @param mdl   {<} model object being passed through the system (compiled/fitted)
// @return      {boolean} the predicted values for a given model
models.theano.NN.predict:{[data;mdl]
  models.theano.predictModel[models.i.npArray data`xtest;mdl]`
  }

 
// load required python modules and functions
models.i.npArray          :.p.import[`numpy]`:array;

models.theano.buildModel  :.p.get[`buildModel]
models.theano.trainModel  :.p.get`fitModel
models.theano.predictModel:.p.get[`predictModel]

