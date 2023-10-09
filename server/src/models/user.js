import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({

    phone: {
        type: String,
        required: [true, 'is required'],
        unique: [true, 'Phone already in use'],
        trim: true
    },
    username: {
        type: String,
        unique: [true, 'username already in use'],
    },
    name: {
        type: String
    },
    followers: [{
      type: mongoose.Schema.ObjectId,
      ref: "Users",
    }],
    following: [{
        type: mongoose.Schema.ObjectId,
        ref: "Users",
      }],
    created_at: {
        type: Date,
        default: Date.now
    },
    updated_at: {
        type: Date
    }
})



userSchema.pre('save', async function save(next) {
    this.increment();

    this.updated_at = new Date;
    return next();
});

let user = mongoose.model('Users', userSchema)

export default {
    user
}