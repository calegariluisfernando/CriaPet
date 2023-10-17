<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Raca extends Model
{
    use HasFactory;

    protected $table = 'Raca';
    protected $fillable = ['nome'];

    protected static function boot()
    {
        parent::boot();
        static::creating(fn(Raca $raca) => $raca->nome = trim($raca->nome));
    }

    public function especie()
    {
        return $this->belongsTo(Especie::class, 'especie_id', 'id');
    }
}
