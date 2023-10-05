<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Especie extends Model
{
    use HasFactory;

    protected $table = 'Especie';
    protected $fillable = ['name'];

    protected static function boot()
    {
        parent::boot();
        static::creating(fn(Especie $especie) => $especie->name = trim($especie->name));
    }
}
