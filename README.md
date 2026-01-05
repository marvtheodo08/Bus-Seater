# Bus Seater
Welcome to Bus Seater, the world's first school bus seating app!
## How it works
The user has the option to sign up for one of 3 account types:
- Student Account
- Driver Account
- Admin Account

A student account allows a student to pick their seat for the week. When a user signs up for a student account, there is an authetication process to verify if the info is true, specifcally their first and last name, their grade level, their school (via the school id), and their bus (via the bus id). Once everything is verified, starting from 4pm on Friday and until 8pm on Friday, they are able to pick their seat for the following week. However, if a school is on break for a particular week, the student will not be able to pick their seat for that week.

The driver oversees the students on their own bus. A strike system is implemented to keep students in check so they can still pick their seats. If the student does mischief, the driver for that student's bus can give them a strike, and they will not be able to pick their seat for the following week. For their 1st two strikes, the student will be allowed to pick their seats again starting on the following Monday, and a cron-job runs every Monday to ensure students get unbanned on time. After three stikes, however, the student can not pick their seat for the rest of the quarter! After the quarter, their strikes resets back to 0 using an addditional cron-job, which runs every day. If a student doesn't have an account, the driver can assign them their own seat.

The admin can set up breaks and the quarters, and they are able to create buses as well and add students to buses using their first and last name, and grade level.

This app ensures that everyone has a seat they are happy in without rushing the bus, and helps create a healthy, behaved enviroment for everyone on the bus.

Anything account related, such as creation and login, is handled with FirebaseAuth, but user data, such as their first and last name, email, school id, and account type, will be added to a MySQL database once the account is created.

The app was coded entierly with Swift, with SwiftUI being its core user interface, and uses both JSON parsing and stringification to interact with the database. The database was built with MySQL, hosted via AWS, and the backend API was built using Python and Flask, hosted via Render.
