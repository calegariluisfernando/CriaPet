<?php

return [
    'secret' => env('FIREBASE_API_KEY', 'petguard'),
    'ttl' => env('JWT_TTL', 43200), // 12 horas
];
