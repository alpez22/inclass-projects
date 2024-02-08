import { NavigationContainer } from '@react-navigation/native';
import { useState, useEffect } from 'react';

import BadgerTabs from './navigation/BadgerTabs';
import BadgerContext from "./BadgerContext";

export default function BadgerNews(props) {
  EXPO_PUBLIC_CS571_BADGER_ID = "bid_9158dc6b99613b138a68b5b7f78b477bde0c864a85847fc770899d25c9161f49";
  const [prefs, setPrefs] = useState({});

  useEffect(() => {
    fetch("https://cs571.org/api/f23/hw8/articles", {
      headers: {
          "X-CS571-ID": EXPO_PUBLIC_CS571_BADGER_ID
      }
    })
    .then(res => res.json())
    .then(data => {
      const uniqueTagsSet = new Set();
        data.forEach(article => {
            article.tags.forEach(tag => uniqueTagsSet.add(tag));
        });
        const defaultPrefs = Array.from(uniqueTagsSet).reduce((pref, tag) => {
          pref[tag] = true; // all tags are defaulted as true
          return pref;
        }, {});
        setPrefs(defaultPrefs);
    })
    .catch((error) => console.error("Error thrown in fetch: ", error));
  }, []);

  return (
    <BadgerContext.Provider value={[prefs, setPrefs]}>
      <NavigationContainer>
        <BadgerTabs/>
      </NavigationContainer>
    </BadgerContext.Provider>
  );
}