"""Welcome to Reflex! This file outlines the steps to create a basic app."""

import reflex as rx

from rxconfig import config
from sqlmodel import delete, select
import time

class User(rx.Model, table=True):
    username: str
    email: str
    password: str



class State(rx.State):
    name: str = "test"
    users: list[User] = []
    
    @rx.var
    def get_users(self) -> list[User]:
        with rx.session() as session:
            users = session.exec(
                select(User)
            ).all()
        return users

    def add_user(self):
        starttime = time.time()
        with rx.session() as session:
            session.add(
                User(
                    username="test",
                    email="admin@reflex.dev",
                    password="admin",
                )
            ), 
            session.commit()
        endtime = time.time()
        print(f"Time taken: {endtime - starttime} seconds")
    
    def del_user(self):
        with rx.session() as session:
            session.exec(
                delete(User)
                .where(User.username == "test")
            )
            session.commit()





def index() -> rx.Component:
    # Welcome Page (Index)
    return rx.container(
        rx.vstack(
            rx.hstack(
                rx.button("Add User", on_click=State.add_user),
                rx.button("Delete User", on_click=State.del_user),
            ),
            rx.text(State.get_users),
            # rx.button("Load Users", on_click=State.get_users),
        ),
    )


app = rx.App()
app.add_page(index)
