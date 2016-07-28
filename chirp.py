from flask import Flask, render_template, request, redirect, session
import pg
import datetime
import bcrypt

db = pg.DB(dbname='chirp_db')

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
    query = db.query("select email, password from a_user where a_user.email =$1", user_email)
    # print query.namedresult()
    db_password = query.dictresult()[0]
    if bcrypt.hashpw(user_password.encode('utf-8'), db_password['password']) == db_password['password']:
        session['email']= request.form['email']
        return redirect('/timeline')
    else:
        return redirect('/signup')
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
            tweet.user_id = 1 or tweet.user_id in
        (select
            followee_id
        from
            follow
        where
            follow.follower_id = 1)
        order by
            tweet.time_stamp desc
    ''')
    tweets = query.namedresult()
    return render_template('timeline.html', title='Timeline', tweets= tweets)



@app.route('/profile')
def display_profile():
    query = db.query('''
        select
			a_user.name,
			a_user.user_name,
            tweet.tweet,
            tweet.time_stamp
        from a_user
        left outer join
        	tweet on a_user.id = tweet.user_id
        where a_user.id = 1
    ''')
    tweets = query.namedresult()
    user_info = db.query('''
        select
	       a_user.name,
	       a_user.user_name,
	       a_user.bio,
	       count(tweet.tweet) as tweet_count
        from
	       a_user
        inner join
	       tweet on a_user.id = tweet.user_id
        where
            a_user.id = 1
        group by
            a_user.id
    ''')
    tweet_counts = user_info.namedresult()
    return render_template('profile.html', title='Profile', tweets= tweets, tweet_counts = tweet_counts)


@app.route('/chirp', methods=['POST'])
def chirp():
    chirp = request.form['chirp']
    time = datetime.datetime.now()
    db.insert('tweet', user_id=1, tweet= chirp, time_stamp = time)
    return redirect('/timeline')

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
