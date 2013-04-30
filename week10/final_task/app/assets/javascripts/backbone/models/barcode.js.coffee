class FinalTask.Models.Barcode extends Backbone.Model
  paramRoot: 'barcode'

  # defaults: {}

class FinalTask.Collections.BarcodesCollection extends Backbone.Collection
  model: FinalTask.Models.Barcode
  url: '/barcodes'
