<?php

namespace App\Http\Controllers;

use App\Models\Animal;

class AnimalController extends Controller
{
    public function index()
    {
        $animais = Animal::with(['users'])->get();

        return $animais;

        return $animais;
    }
}
