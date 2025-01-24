const { execSync } =require('child_process');

// Get git hash with fallback
const getGitHash = () => {
  try {
    return execSync('git rev-parse --short HEAD').toString().trim();
  } catch {
    return 'no-git-info';
  }
};

let commitJson = {
  hash: JSON.stringify(getGitHash()),
  version: JSON.stringify(process.env.npm_package_version),
};

console.log(`
★═══════════════════════════════════════★
        💪🏾  A G E N T . R E I D ⭐
         🏆  Top of the Line  🏆
★═══════════════════════════════════════★
`);
console.log('🎯 Current Version:', `v${commitJson.version}`);
console.log('🎯 Commit Hsdh:', commitJson.hash);
console.log('🌐 URL Incoming ⬇️⬇️⬇️ ');
console.log('★═══════════════════════════════════════★');
