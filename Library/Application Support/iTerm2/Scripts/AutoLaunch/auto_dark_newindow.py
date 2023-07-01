#!/usr/bin/env python3

import asyncio
import iterm2

async def update(new_session, partial_profiles):
    # Themes have space-delimited attributes, one of which will be light or dark.
    sess_profile = await new_session.async_get_profile()

    for partial in partial_profiles:
        if partial.name == sess_profile.name:
            full = await partial.async_get_full_profile()
            await new_session.async_set_profile(full)
            return

async def main(connection):
    app = await iterm2.async_get_app(connection)
    partial_profiles = await iterm2.PartialProfile.async_query(connection)

    async with iterm2.NewSessionMonitor(connection) as mon:
        while True:
            # Wait for a new session to be created
            session_id = await mon.async_get()
            session = app.get_session_by_id(session_id)
            await update(session, partial_profiles)

iterm2.run_forever(main)
