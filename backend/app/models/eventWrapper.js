/**
 * Module dependencies.
 */

var mongoose = require('mongoose'),
    config = require('../../config/config.js'),
    User = require('./user').User,
    Event = require('./event').Event,
    Schema = mongoose.Schema;
/**
 *	EventWrapper Schema
 */
var EventWrapperSchema = new Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    owner: {
        type: Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    litterature: {
        type: String
    },
    startDate: {
        type: String,
        required: true
    },
    endDate: {
        type: String,
        required: true
    },
    events: [{
        type: Schema.Types.ObjectId,
        ref: 'Event'
    }]
});

/**
 *   Middleware
 *   Delete all events assosiated with the eventWrapper
 */
EventWrapperSchema.pre('remove', function (next) {
    Event = require('./event').Event;
    for (i = 0; i < this.events.length; i = i + 1) {
        Event.findOne({
            _id: this.events[i]
        }).remove();
    }
    next();
});

/**
 * Methods
 */
EventWrapperSchema.methods.saveToDisk = function (eventWrapper, callback) {
    eventWrapper.save(function (err, eventWrapper) {
        if (err) {
            callback(err, null);
        } else {
            callback(null, eventWrapper);
        }
    });
};

/**
 * Statics
 */
EventWrapperSchema.statics = {
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
        this.find(function (err, eventWrappers) {
            if (err) {
                callback(err, undefined);
            }
            callback(undefined, eventWrappers);
        });
    }
};

var EventWrapper = mongoose.model('EventWrapper', EventWrapperSchema);
module.exports = {
    EventWrapper: EventWrapper
};