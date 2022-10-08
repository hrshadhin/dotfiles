#!/usr/bin/env python3

import os
import time
import subprocess
import gmail
from random import randrange

# set variables
private_mailbox_name = os.getenv("PRIVATE_MAILBOX_NAME", "Private")
private_mailbox_login = (os.getenv("PRIVATE_MAILBOX_USER", ""), os.getenv("PRIVATE_MAILBOX_PASS", ""))
community_mailbox_name = os.getenv("COMMUNITY_MAILBOX_NAME", "Community")
community_mailbox_login = (os.getenv("COMMUNITY_MAILBOX_USER", ""), os.getenv("COMMUNITY_MAILBOX_PASS", ""))
office_mailbox_name = os.getenv("OFFICE_MAILBOX_NAME", "Office")
office_mailbox_login = (os.getenv("OFFICE_MAILBOX_USER", ""), os.getenv("OFFICE_MAILBOX_PASS", ""))

# mail boxes
mailboxes = {
    private_mailbox_name: private_mailbox_login,
    community_mailbox_name: community_mailbox_login,
    office_mailbox_name: office_mailbox_login
}


def get_unseen_emails(username: str, password: str) -> list:
    """
    Login to gmail and get unseen emails

    :param username: str
    :param password: str
    :return: list
    """

    g = gmail.login(username, password)
    unseen_mails = g.inbox().mail(unread=True)
    g.logout()

    return unseen_mails


def main():
    for account_name, access_info in mailboxes.items():
        user, password = access_info
        if len(user) and len(password):
            unseen_mails = get_unseen_emails(user, password)
            total_unseen = len(unseen_mails)
            if total_unseen:
                print(f'You got {total_unseen} new mails in {account_name} mailbox')

            # sleep for 10 sec
            time.sleep(10)
        else:
            print(f"{account_name} mailbox login not provided!")

if __name__ == '__main__':
    main()
