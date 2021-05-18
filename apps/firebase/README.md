## Setup
```bash
npm install -g firebase-tools
firebase login
cd functions/
npm i
```

## Tests
```bash
npm test
```

## Deploy firebase functions

```bash
npm run deploy
```

## Deploy firestore rules

```bash
npm run deploy-rules
```

## Structure
```
functions/
  firestore/
    name/
      onWrite.f.ts

    name2/
      onCreate.f.ts

    name3/
      onUpdate.f.ts

    name4/
      onCreate.f.ts
      onUpdate.f.ts
      onDelete.f.ts

  http/
    name/
      endpointName.f.ts

  schedule/
    jobName.f.ts

  index.ts
```

# Notes
When you deploy these functions a lib/ folder will be generated that contains the transpiled javascript files that get deployed to firebase.
It is highly recommended to delete this folder if it exists prior to deploying the functions. This will ensure that a clean build is being deployed.
