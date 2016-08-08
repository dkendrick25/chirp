from flask import Flask, render_template, request, redirect, session
import pg
import datetime
import bcrypt
from dotenv import load_dotenv, find_dotenv
import os

load_dotenv(find_dotenv())

db = pg.DB( dbname=os.environ.get('DBNAME'),
    host=os.environ.get('DBHOST'),
    port=5432,
    user=os.environ.get('DBUSER'),
    passwd=os.environ.get('DBPASSWORD')
)

app = Flask('ChirpApp')

@app.route('/')
def login():
    if 'email' in session:
        return redirect('/timeline')
    else:
        return render_template('login.html', title="login")

@app.route('/submit_login', methods=['POST'])
def submit_login():
    user_email = request.form['email']
    user_password = request.form['password']
    # the $1 keeps the username anomyous (bobby tables)
    query = db.query("select email, password, id from a_user where a_user.email =$1", user_email)
    # print query.namedresult()
    if len(query.namedresult()) <= 0:
        return redirect('/signup')
    db_password = query.dictresult()[0]
    # print db_password['id']
    if bcrypt.hashpw(user_password.encode('utf-8'), db_password['password']) == db_password['password']:
        session['email']= request.form['email']
        session['id'] = db_password['id']
        return redirect('/timeline')
    return redirect('/')
@app.route('/signup')
def signup():
    return render_template('signup.html', title='Signup')

@app.route('/submit_signup', methods=['POST'])
def submit_signup():
    name = request.form['name']
    user_name = request.form['user_name']
    email = request.form['email']
    bio = request.form['bio']
    password = request.form['password'].encode('utf-8')
    hashed = bcrypt.hashpw(password, bcrypt.gensalt())
    db.insert('a_user', name = name, email = email, user_name = user_name, bio = bio, password= hashed)
    return redirect('/')
@app.route('/timeline')
def display_timeline():
    email = session['email']
    this_user = session['id']
    query = db.query('''
        select
            tweet.tweet,
            tweet.time_stamp,
            tweet.user_id,
            a_user.name,
            a_user.user_name
        from
            tweet
        left outer join
            a_user on tweet.user_id = a_user.id
        where
            tweet.user_id = $1 or tweet.user_id in
        (select
            followee_id
        from
            follow
        where
            follow.follower_id = $1)
        order by
            tweet.time_stamp desc
    ''', this_user)
    tweets = query.namedresult()
    return render_template('timeline.html', title='Timeline', tweets= tweets)



@app.route('/profile')
def display_profile():
    email = session['email']
    this_user = session['id']
    query = db.query('''
            select
			a_user.name,
			a_user.user_name,
            tweet.tweet,
            tweet.time_stamp
        from
            a_user
        left outer join
        	tweet on a_user.id = tweet.user_id
        where
            a_user.id = $1
        order by
            tweet.time_stamp desc
    ''', this_user)
    tweets = query.namedresult()
    tweet_count = db.query('''
        select
	       a_user.name,
	       a_user.user_name,
	       count(tweet.tweet) as tweet_count
        from
	       a_user
        inner join
	       tweet on a_user.id = tweet.user_id
        where
            a_user.id = $1
        group by
            a_user.id
    ''', this_user)
    tweet_counts = tweet_count.namedresult()
    return render_template('profile.html', title='Profile', tweets= tweets, tweet_counts = tweet_counts)

@app.route('/chirp', methods=['POST'])
def chirp():
    chirp = request.form['chirp']
    email = session['email']
    this_user = session['id']

    time = datetime.datetime.now()
    db.insert('tweet', user_id= this_user, tweet= chirp, time_stamp = time)
    return redirect('/timeline')

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')



app.secret_key = 'CSF686CCF85C6FRTCHQDBJDXHBHC1G478C86GCFTDCR'

app.debug = True

if __name__ == '__main__':
    app.run(debug=True)

# get the count of followers
# select
# 	         a_user.user_name,
# 	         follow.follower_id,
# 	         count(follow.followee_id) as following_count
#         from a_user
#         left outer join
#         	follow on a_user.id = follow.follower_id
#         where
#         	a_user.id = 1
#         group by a_user.id, follow.follower_id
