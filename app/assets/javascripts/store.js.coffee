# http://emberjs.com/guides/models/using-the-store/

DS.RESTAdapter.reopen
  namespace: "api/v1"

#BurnLevel.Store = DS.Store.extend
#  revision: 12,
#  adapter:  BurnLevel.Adapter.create()
