from pymongo import MongoClient

def db():
    mongo = MongoClient('mongodb://mongo:27017/')
    return mongo.admitad
