const imageNames = require.context(
  '../images',
  false,
  /\.(png|svg|jpe?g|gif|ico)$/i
)

imageNames.forEach(function(imageName) {
  require('../images/' + imageName)
})
