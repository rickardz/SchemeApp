/**
 * Module dependencies.
 */

var mongoose = require('mongoose'),
    config = require('../../config/config.js'),
    User = require('./user.js'),
    Schema = mongoose.Schema;


var MessageSchema = new Schema({
    text: {
        type: String,
        required: true,
        trim: true
    },
    date: {
        type: String,
        required: true,
        trim: true
    },
    from: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    receivers: [{
        type: Schema.Types.ObjectId,
        ref: 'User'
    }]
});

/**
 * Methods
 */
MessageSchema.methods.saveToDisk = function (message, callback) {
    message.save(function (err, message) {
        if (err) {
            callback(err, null);
        } else {
            callback(null, message);
        }
    });
};

/**
 * Statics
 */

MessageSchema.statics = {

    load: function (id, callback) {
        this.findOne({
            _id: id
        })
            .populate('_id', 'id')
            .exec(callback);
    },

    /**
     * List
     */
    list: function (callback) {
        this.find(function (err, Messages) {
            if (err) {
                callback(err, undefined);
            }
            callback(undefined, Messages);
        });
    }
};

var Message = mongoose.model('Message', MessageSchema);
module.exports = {
    Message: Message
};